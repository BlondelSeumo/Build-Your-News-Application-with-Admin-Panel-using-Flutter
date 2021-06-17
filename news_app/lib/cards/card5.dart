import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/pages/article_details.dart';
import 'package:news_app/pages/video_article_details.dart';
import 'package:news_app/utils/cached_image.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/widgets/video_icon.dart';

class Card5 extends StatelessWidget {
  final Article d;
  final String heroTag;
  const Card5({Key key, @required this.d, @required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(5),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Theme.of(context).shadowColor, blurRadius: 10, offset: Offset(0, 3))
            ]),
        child: Wrap(
          children: [
            Hero(
              tag: heroTag,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    child: CustomCacheImage(
                      imageUrl: d.thumbnailImagelUrl,
                      radius: 5.0,
                      circularShape: false,
                    ),
                  ),
                  VideoIcon(contentType: d.contentType, iconSize: 80,)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        CupertinoIcons.time,
                        size: 16,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        d.date,
                        style: TextStyle(fontSize: 12, color: Theme.of(context).secondaryHeaderColor),
                      ),
                      Spacer(),
                      Icon(
                        Icons.favorite,
                        size: 16,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        d.loves.toString(),
                        style: TextStyle(fontSize: 12, color: Theme.of(context).secondaryHeaderColor),
                      )
                    ],
                  )
                ],
              ),
            ),
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
