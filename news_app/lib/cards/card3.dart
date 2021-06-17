import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/pages/article_details.dart';
import 'package:news_app/pages/video_article_details.dart';
import 'package:news_app/utils/cached_image.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/widgets/video_icon.dart';

class Card3 extends StatelessWidget {
  final Article d;
  final String heroTag;
  final bool replace;
  const Card3({Key key, @required this.d, @required this.heroTag, this.replace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 10,
                    offset: Offset(0, 3))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: heroTag == null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: CustomCacheImage(
                                imageUrl: d.thumbnailImagelUrl, radius: 5.0),
                          ),
                          VideoIcon(
                            contentType: d.contentType,
                            iconSize: 60,
                          )
                        ],
                      )
                    : Hero(
                        tag: heroTag,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: CustomCacheImage(
                                  imageUrl: d.thumbnailImagelUrl, radius: 5.0),
                            ),
                            VideoIcon(
                              contentType: d.contentType,
                              iconSize: 60,
                            )
                          ],
                        ),
                      ),
              ),
              SizedBox(
                width: 15,
              ),
              Flexible(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      d.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blueGrey[600]),
                      child: Text(
                        d.category,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.time,
                          color: Theme.of(context).secondaryHeaderColor,
                          size: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          d.date,
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 13),
                        ),
                        Spacer(),
                        Icon(
                          Icons.favorite,
                          color: Colors.grey,
                          size: 20,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(d.loves.toString(),
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 13)),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
      onTap: () {
        if (replace == null) {
          d.contentType == 'video'
              ? nextScreen(
                  context,
                  VideoArticleDetails(
                    data: d,
                    tag: heroTag,
                  ))
              : nextScreen(
                  context,
                  ArticleDetails(
                    data: d,
                    tag: heroTag,
                  ));
        } else {
          d.contentType == 'video'
              ? nextScreenReplace(
                  context,
                  VideoArticleDetails(
                    data: d,
                    tag: heroTag,
                  ))
              : nextScreenReplace(
                  context,
                  ArticleDetails(
                    data: d,
                    tag: heroTag,
                  ));
        }
      },
    );
  }
}
