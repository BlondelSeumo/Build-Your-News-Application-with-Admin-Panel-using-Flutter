import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/pages/article_details.dart';
import 'package:news_app/pages/video_article_details.dart';
import 'package:news_app/utils/cached_image.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/widgets/video_icon.dart';

class FeaturedCard extends StatelessWidget {
  final Article d;
  final heroTag;
  const FeaturedCard({Key key, @required this.d, @required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(15),
        child: Stack(
          children: <Widget>[
            Hero(
              tag: heroTag,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.black12,borderRadius: BorderRadius.circular(5),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 10,
                              offset: Offset(0, 3))
                        ]),

                    child: CustomCacheImage(imageUrl: d.thumbnailImagelUrl, radius: 5),
                  ),
                  VideoIcon(contentType: d.contentType, iconSize: 80,)
                ],
              ),
            ),

            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10,),
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.deepPurpleAccent.withOpacity(0.7)),
                      child: Text(
                        d.category,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    Container(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black45),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.favorite,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              d.loves.toString(),
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
            ),
            
            
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        d.title,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(CupertinoIcons.time, size: 16, color: Colors.white),
                          SizedBox(
                            width: 5,
                          ),
                          Text(d.date,
                              style: TextStyle(color: Colors.white, fontSize: 13))
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
      onTap: (){
        d.contentType == 'video'
        ? nextScreen(context, VideoArticleDetails(
          data: d,
          tag: heroTag,
        ))
        : nextScreen(context, ArticleDetails(
          data: d,
          tag: heroTag,
        ));
      }
    );
  }
}