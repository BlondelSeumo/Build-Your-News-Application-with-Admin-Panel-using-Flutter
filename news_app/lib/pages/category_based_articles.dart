import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:news_app/blocs/theme_bloc.dart';
import 'package:news_app/cards/sliver_card.dart';
import 'package:news_app/cards/sliver_card1.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/models/custom_color.dart';
import 'package:news_app/utils/cached_image.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class CategoryBasedArticles extends StatefulWidget {
  final String category;
  final String categoryImage;
  final String tag;
  CategoryBasedArticles({Key key, @required this.category, @required this.categoryImage, @required this.tag}) : super(key: key);

  @override
  _CategoryBasedArticlesState createState() => _CategoryBasedArticlesState();
}

class _CategoryBasedArticlesState extends State<CategoryBasedArticles> {


  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionName = 'contents';
  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<Article> _data = [];
  bool _hasData;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
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
    setState(() => _hasData = true);
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection(collectionName)
          .where('category', isEqualTo: widget.category)
          .orderBy('timestamp', descending: true)
          .limit(8)
          .get();
    else
      data = await firestore
          .collection(collectionName)
          .where('category', isEqualTo: widget.category)
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible['timestamp']])
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
      if(_lastVisible == null){

        setState(() {
          _isLoading = false;
          _hasData = false;
          print('no items');
        });

        

      }else{

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
              expandedHeight: MediaQuery.of(context).size.height * 0.20,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                background: Hero(
                  tag: widget.tag, 
                  child: ColorFiltered(
                    child: CustomCacheImage(imageUrl: widget.categoryImage, radius: 0.0),
                    colorFilter: ColorFilter.mode(Colors.grey[500], BlendMode.darken),
                  ),
                ),
                title: Text(
                  widget.category,
                  
                ),
                titlePadding: EdgeInsets.only(left: 20, bottom: 15, right: 20),
              ),
            ),


            _hasData == false ?

            SliverFillRemaining(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.30,),
                  EmptyPage(icon: Feather.clipboard, message: 'no articles found'.tr(), message1: ''),
                ],
              )
            )

            : SliverPadding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                sliver : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < _data.length) {
                      if(index %2 == 0 &&index != 0) return SliverCard1(d: _data[index], heroTag: 'categorybased$index',);
                      return SliverCard(d: _data[index], heroTag: 'categorybased$index',);
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
                  childCount: _data.length  == 0 ? 5  : _data.length+ 1,
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