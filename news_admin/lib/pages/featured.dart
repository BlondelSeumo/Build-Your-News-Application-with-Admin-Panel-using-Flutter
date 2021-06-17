
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_admin/blocs/admin_bloc.dart';
import 'package:news_admin/models/article.dart';
import 'package:news_admin/pages/update_content.dart';
import 'package:news_admin/utils/cached_image.dart';
import 'package:news_admin/utils/dialog.dart';
import 'package:news_admin/utils/empty.dart';
import 'package:news_admin/utils/next_screen.dart';
import 'package:provider/provider.dart';
import '../utils/styles.dart';
import 'comments.dart';

class FeaturedArticles extends StatefulWidget {
  const FeaturedArticles({Key key}) : super(key: key);

  @override
  _FeaturedArticlesState createState() => _FeaturedArticlesState();
}

class _FeaturedArticlesState extends State<FeaturedArticles> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<Article> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String collectionName = 'contents';
  DocumentSnapshot _lastVisible;
  bool _hasData;

  @override
  void initState() {
    super.initState();
    if(this.mounted){
      _isLoading = true;
      _getData();
    }
  }

  

  Future<Null> _getData() async {
    await context.read<AdminBloc>().getFeaturedList()
    .then((featuredList) async {
      if(featuredList.isNotEmpty){

        setState(()=> _hasData = true);
        QuerySnapshot data;
      if (_lastVisible == null)
      data = await firestore
          .collection(collectionName)
          .where('timestamp', whereIn: featuredList)
          .limit(10)
          .get();




    if (data.docs.isNotEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Article.fromFirestore(e)).toList();
        });
      }
    } else {
      setState((){
        _isLoading = false;
        _hasData = false;
      });
    }
    return null;


      }else{
        return null;
      }

    });
    
  }



  navigateToReviewPage(context, timestamp, name) {
    nextScreenPopuup(
        context,
        CommentsPage(
          timestamp: timestamp,
        ));
  }




  



  reloadData (){
    setState(() {
      _isLoading = true;
      _lastVisible = null;
      _snap.clear();
      _data.clear();
    });
    _getData();
  }





  openFeaturedDialog (String timestamp) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(50),
            elevation: 0,
            children: <Widget>[
              Text('Remove from Featured',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
              SizedBox(
                height: 10,
              ),
              Text('Do you want to remove this item from the featured list?',
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
                        openDialog(context, 'You are a Tester', 'Only admin can do this');
                      } else {
                        await context.read<AdminBloc>().removefromFeaturedList(context, timestamp)
                        .then((value) => context.read<AdminBloc>().decreaseCount('featured_count'));
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



  




  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Featured Articles',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 10),
          height: 3,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.indigoAccent,
              borderRadius: BorderRadius.circular(15)),
        ),
        Expanded(
          child: _hasData == false ? emptyPage(Icons.content_paste, 'No data available.\nYou can add upto 10 articles here')
          
          : RefreshIndicator(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 30, bottom: 20),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _data.length + 1,
              itemBuilder: (_, int index) {
                if (index < _data.length) {
                  return dataList(_data[index]);
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
      ],
    );
  }




  Widget dataList(Article d) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 5, bottom: 5),
      height: 165,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),),
            child: CustomCacheImage(imageUrl: d.thumbnailImagelUrl, radius: 10,),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        d.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(LineIcons.map_marker, size: 15, color: Colors.grey),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        d.category,
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.access_time, size: 15, color: Colors.grey),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        d.date,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 35,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.favorite,
                              size: 16,
                              color: Colors.grey,
                            ),
                            Text(
                              d.loves.toString(),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        child: Container(
                          height: 35,
                          width: 45,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(
                            Icons.comment,
                            size: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        onTap: () {
                          navigateToReviewPage(context, d.timestamp, d.title);
                        },
                      ),
                      
                      SizedBox(width: 10),
                      InkWell(
                        child: Container(
                            height: 35,
                            width: 45,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.edit,
                                size: 16, color: Colors.grey[800])),
                        onTap: () {
                          nextScreen(context, UpdateContent(data: d));
                        },
                      ),
                      SizedBox(width: 10),

                      Container(
                        height: 35,
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey[300]),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextButton.icon(
                            onPressed: () => openFeaturedDialog(d.timestamp),
                            icon: Icon(LineIcons.close),
                            label: Text('Remove from featured')),
                      ),
                      
                      
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
