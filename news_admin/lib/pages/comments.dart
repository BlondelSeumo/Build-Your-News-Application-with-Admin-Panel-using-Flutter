
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_admin/blocs/admin_bloc.dart';
import 'package:news_admin/blocs/comment_bloc.dart';
import 'package:news_admin/models/comment.dart';
import 'package:news_admin/utils/dialog.dart';
import 'package:news_admin/utils/toast.dart';
import 'package:news_admin/widgets/cover_widget.dart';
import 'package:provider/provider.dart';

import '../utils/styles.dart';



class CommentsPage extends StatefulWidget {
  
  final String timestamp;
  const CommentsPage(
      {Key key,
      @required this.timestamp,})
      : super(key: key);

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
  var textFieldCtrl = TextEditingController();
  

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }




  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection('$collectionName/${widget.timestamp}/comments')
          .orderBy('timestamp', descending: true)
          .limit(15)
          .get();
    else
      data = await firestore
          .collection('$collectionName/${widget.timestamp}/comments')
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible['timestamp']])
          .limit(15)
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
      setState(() => _isLoading = false);
      openToast(context, 'No more reviews available!');
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  



  handleDelete(context, Comment d) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(50),
            elevation: 0,
            children: <Widget>[
              Text('Delete?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
              SizedBox(
                height: 10,
              ),
              Text('Want to delete this item from the database?',
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Row(
                children: <Widget>[
                  TextButton(
                    style: buttonStyle(Colors.redAccent),
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      if (ab.userType == 'tester') {
                        Navigator.pop(context);
                        openDialog(context, 'You are a Tester','Only admin can delete comments');
                      } else {
                        await context.read<CommentBloc>().deleteComment(widget.timestamp, d.uid, d.timestamp)
                        .then((value) => openToast1(context, 'Comment deleted successfully'));
                        reloadData();
                        Navigator.pop(context);
                      }
                      
                    },
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    style: buttonStyle(Colors.deepPurpleAccent),
                    child: Text(
                      'No',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ))
            ],
          );
        });
  }

  

  clearTextFields() {
    textFieldCtrl.clear();
  }

  reloadData() {
    setState(() {
      _isLoading = true;
      _snap.clear();
      _data.clear();
      _lastVisible = null;
      
    });
    _getData();
  }




  handleSubmit(value) async {
    final  ab = context.read<AdminBloc>();
    if(ab.userType == 'tester'){
      openDialog(context, 'You are a Tester','Only admin can make comments');
    }else{
      if (value.isEmpty) {
      openDialog(context, 'Write A Comment!', '');
    } else {
      await context
          .read<CommentBloc>()
          .saveNewComment(widget.timestamp, textFieldCtrl.text)
          .then((value) => openToast(context, 'Comment added successfully!'));
      clearTextFields();
      reloadData();
    }
    }
  }



  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: false,
          title: Text('Comments'),
          elevation: 1,
        ),
        body: CoverWidget(
          widget: Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    controller: controller,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: _data.length + 1,
                    itemBuilder: (_, int index) {
                      if (index < _data.length) {
                        return reviewList(_data[index]);
                      }
                      return Center(
                        child: new Opacity(
                          opacity: _isLoading ? 1.0 : 0.0,
                          child: new SizedBox(
                              width: 32.0,
                              height: 32.0,
                              child: new CircularProgressIndicator()),
                        ),
                      );
                    },
                  ),
                  onRefresh: () async {
                    reloadData();
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
                  padding:
                      EdgeInsets.only(top: 8, bottom: 10, right: 20, left: 20),
                  width: double.infinity,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25)),
                    child: TextFormField(
                      decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: 0),
                          contentPadding:
                              EdgeInsets.only(left: 15, top: 10, right: 5),
                          border: InputBorder.none,
                          hintText: 'Write a comment',
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.grey[700],
                              size: 20,
                            ),
                            //onPressed: null,
                            onPressed: () => handleSubmit(textFieldCtrl.text),
                          )),
                      controller: textFieldCtrl,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget reviewList(Comment d) {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(d.imageUrl),
          ),
          title: Row(
            children: <Widget>[
              Text(
                d.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 5,
              ),
              Text(d.date,
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          subtitle: Text(
                  d.comment,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                handleDelete(context, d);
              }),
        ));
  }




  
}
