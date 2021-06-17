import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/comments_bloc.dart';
import '../blocs/internet_bloc.dart';
import '../blocs/sign_in_bloc.dart';
import '../models/comment.dart';
import '../utils/dialog.dart';
import '../utils/empty.dart';
import '../utils/sign_in_dialog.dart';
import '../utils/toast.dart';



class CommentsPage extends StatefulWidget {
  final String timestamp;
  const CommentsPage({Key key, @required this.timestamp}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionName = 'contents';
  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<Comment> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var textCtrl = TextEditingController();
  bool _hasData;







  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }




  Future<Null> _getData() async {
    setState(() => _hasData = true);
    await context.read<CommentsBloc>().getFlagList();
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection('$collectionName/${widget.timestamp}/comments')
          .orderBy('timestamp', descending: true)
          .limit(12)
          .get();
    else
      data = await firestore
          .collection('$collectionName/${widget.timestamp}/comments')
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible['timestamp']])
          .limit(12)
          .get();

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Comment.fromFirestore(e)).toList();
        });
      }
    } else {
      if (_lastVisible == null) {
        setState(() {
          _isLoading = false;
          _hasData = false;
          print('no items');
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasData = true;
          print('no more items');
        });
      }
    }
    return null;
  }



  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }



  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }




  openPopupDialog(Comment d) {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(20),
            children: [
              ListTile(
                title: Text('flag this comment').tr(),
                leading: Icon(Icons.flag),
                onTap: () async {
                  await context
                      .read<CommentsBloc>()
                      .addToFlagList(context, d.timestamp)
                      .then((value) => onRefreshData());
                  Navigator.pop(context);
                },
              ),
              context.watch<CommentsBloc>().flagList.contains(d.timestamp)
                  ? ListTile(
                      title: Text('unflag this comment').tr(),
                      leading: Icon(Icons.flag_outlined),
                      onTap: () async {
                        await context
                            .read<CommentsBloc>()
                            .removeFromFlagList(context, d.timestamp)
                            .then((value) => onRefreshData());
                        Navigator.pop(context);
                      },
                    )
                  : Container(),
              ListTile(
                title: Text('report').tr(),
                leading: Icon(Icons.report),
                onTap: () {
                  handleReport(d);
                },
              ),
              sb.uid == d.uid
                  ? ListTile(
                      title: Text('delete').tr(),
                      leading: Icon(Icons.delete),
                      onTap: () => handleDelete(d),
                    )
                  : Container()
            ],
          );
        });
  }



  Future handleReport(Comment d) async {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    if (sb.isSignedIn == true) {
      await context.read<CommentsBloc>().reportComment(widget.timestamp, d.uid, d.timestamp);
      Navigator.pop(context);
      openDialog(context, "report-info".tr(),"report-info1".tr());
    } else {
      Navigator.pop(context);
      openDialog(context, "report-guest".tr(),"report-guest1".tr());
    }
  }




  Future handleDelete(Comment d) async {
    final ib = Provider.of<InternetBloc>(context, listen: false);
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    await ib.checkInternet();
    if (ib.hasInternet == false) {
      Navigator.pop(context);
      openToast(context, 'no internet'.tr());
    } else {
      await context
          .read<CommentsBloc>()
          .deleteComment(widget.timestamp, sb.uid, d.timestamp)
          .then((value) => openToast(context, 'Deleted Successfully!'));
      onRefreshData();
      Navigator.pop(context);
    }
  }





  Future handleSubmit() async {
    final ib = Provider.of<InternetBloc>(context, listen: false);
    final SignInBloc sb = context.read<SignInBloc>();
    if (sb.guestUser == true) {
      openSignInDialog(context);
    } else {
      await ib.checkInternet();
      if (textCtrl.text == null || textCtrl.text.isEmpty) {
        print('Comment is empty');
      } else {
        if (ib.hasInternet == false) {
          openToast(context, 'no internet'.tr());
        } else {
          context
              .read<CommentsBloc>()
              .saveNewComment(widget.timestamp, textCtrl.text);
          onRefreshData();
          textCtrl.clear();
          FocusScope.of(context).requestFocus(new FocusNode());
        }
      }
    }
  }

  onRefreshData() {
    setState(() {
      _isLoading = true;
      _snap.clear();
      _data.clear();
      _lastVisible = null;
    });
    _getData();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('comments').tr(),
        titleSpacing: 0,
        actions: [
          IconButton(
              icon: Icon(
                Feather.rotate_cw,
                size: 22,
              ),
              onPressed: () => onRefreshData())
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              child: _hasData == false
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                        ),
                        EmptyPage(
                            icon: LineIcons.comments,
                            message: 'no comments found'.tr(),
                            message1: 'be the first to comment'.tr()),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(15),
                      controller: controller,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _data.length != 0 ? _data.length + 1 : 10,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (_, int index) {
                        if (index < _data.length) {
                          return _commentCard(_data[index]);
                        }
                        return Opacity(
                          opacity: _isLoading ? 1.0 : 0.0,
                          child: _lastVisible == null
                              ? LoadingCard(height: 100)
                              : Center(
                                  child: SizedBox(
                                      width: 32.0,
                                      height: 32.0,
                                      child: new CupertinoActivityIndicator()),
                                ),
                        );
                      },
                    ),
              onRefresh: () async {
                onRefreshData();
              },
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black26,
          ),
          SafeArea(
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 8, bottom: 10, right: 20, left: 20),
              width: double.infinity,
              color: Theme.of(context).primaryColorLight,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    borderRadius: BorderRadius.circular(25)),
                child: TextFormField(
                  decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 0),
                      contentPadding:
                          EdgeInsets.only(left: 15, top: 10, right: 5),
                      border: InputBorder.none,
                      hintText: 'write a comment'.tr(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 20,
                        ),
                        onPressed: () {
                          handleSubmit();
                        },
                      )),
                  controller: textCtrl,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget _commentCard(Comment d) {
    return InkWell(
      child: Container(
          child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              backgroundImage: CachedNetworkImageProvider(d.imageUrl),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 3),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      //border: Border.all(color: Colors.grey[700], width: 0.5),
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        d.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      context
                              .read<CommentsBloc>()
                              .flagList
                              .contains(d.timestamp)
                          ? Text('comment flagged').tr()
                          : Text(
                              d.comment,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColorDark
                                  
                                  ),
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    d.date,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600]),
                  ),
                )
              ],
            ),
          )
        ],
      )),
      onLongPress: () {
        openPopupDialog(d);
      },
    );
  }

  
}
