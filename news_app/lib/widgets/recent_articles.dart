import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/recent_articles_bloc.dart';
import 'package:news_app/cards/card2.dart';
import 'package:news_app/cards/card4.dart';
import 'package:news_app/cards/card5.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class RecentArticles extends StatefulWidget {
  RecentArticles({Key key}) : super(key: key);

  @override
  _RecentArticlesState createState() => _RecentArticlesState();
}

class _RecentArticlesState extends State<RecentArticles> {
  @override
  Widget build(BuildContext context) {
    final rb = context.watch<RecentBloc>();

    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 22,
                  width: 4,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(
                  width: 6,
                ),
                Text('recent news',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)).tr(),
                
              ],
            )),

        ListView.separated(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          physics: NeverScrollableScrollPhysics(),
          itemCount: rb.data.length != 0 ? rb.data.length + 1 : 1,
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 15,),
          
          shrinkWrap: true,
          itemBuilder: (_, int index) {

            if (index < rb.data.length) {
              if(index %3 == 0 && index != 0) return Card5(d: rb.data[index], heroTag: 'recent$index');
              if(index %5 == 0 && index != 0) return Card4(d: rb.data[index], heroTag: 'recent$index');
              else return Card2(d: rb.data[index], heroTag: 'recent$index',);
            }
            return Opacity(
                opacity: rb.isLoading ? 1.0 : 0.0,
                child: Center(
                  child: SizedBox(
                      width: 32.0,
                      height: 32.0,
                      child: new CupertinoActivityIndicator()),
                ),
              
            );
          },
        )
      ],
    );
  }
}

