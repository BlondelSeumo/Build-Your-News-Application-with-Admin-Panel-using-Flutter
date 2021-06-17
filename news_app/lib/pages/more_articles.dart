import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/theme_bloc.dart';
import 'package:news_app/cards/sliver_card.dart';
import 'package:news_app/cards/sliver_card1.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/models/custom_color.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';




class MoreArticles extends StatefulWidget {

  final String title;
  MoreArticles({Key key, @required this.title}) : super(key: key);

  @override
  _MoreArticlesState createState() => _MoreArticlesState();
}

class _MoreArticlesState extends State<MoreArticles> {



  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionName = 'contents';
  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<Article> _data = [];
  bool _descending;
  String _orderBy;




  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _orderBy = 'loves';
    _descending = true;
    _getData();
  }




  onRefresh() {
    setState(() {
      _snap.clear();
      _data.clear();
      _isLoading = true;
      _lastVisible = null;
    });
    _getData();
  }




  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection(collectionName)
          .orderBy(_orderBy, descending: _descending)
          .limit(8)
          .get();

    else data = await firestore
          .collection(collectionName)
          .orderBy(_orderBy, descending: _descending)
          .startAfter([_lastVisible[_orderBy]])
          .limit(8)
          .get();

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Article.fromFirestore(e)).toList();
        });
      }
    } else {
      setState(() => _isLoading = false);
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




  @override
  Widget build(BuildContext context) {
    final tb = context.watch<ThemeBloc>();
    return Scaffold(
      body: RefreshIndicator(
        child: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
              backgroundColor: tb.darkTheme == false ? CustomColor().sliverHeaderColorLight : CustomColor().sliverHeaderColorDark,
              expandedHeight: MediaQuery.of(context).size.height * 0.15,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                background: Container(
                  color: tb.darkTheme == false ? CustomColor().sliverHeaderColorLight : CustomColor().sliverHeaderColorDark,
                  width: double.infinity,
                ),
                title: Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                  
                ).tr(),
                titlePadding: EdgeInsets.only(left: 20, bottom: 15, right: 20),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                sliver : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < _data.length) {
                      if(index %2 == 0 &&index != 0) return SliverCard1(d: _data[index], heroTag: 'more$index',);
                      return SliverCard(d: _data[index], heroTag: 'more$index',);
                    }
                    return Opacity(
                  opacity: _isLoading ? 1.0 : 0.0,
                  child: _lastVisible == null
                  ? Column(
                    children: [
                      LoadingCard(height: 200,),
                      SizedBox(height: 15,)
                    ],
                  )
                  : Center(
                    child: SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: new CupertinoActivityIndicator()),
                  ),
                
                    );
                  },
                  childCount: _data.length  == 0 ? 6  : _data.length+ 1,
                ),
              ),
            )
          ],
        ),
        onRefresh: () async => onRefresh(),
      ),
    );
  }
}
