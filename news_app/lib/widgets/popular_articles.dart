import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/popular_articles_bloc.dart';
import 'package:news_app/cards/card1.dart';
import 'package:news_app/pages/more_articles.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class PopularArticles extends StatelessWidget {
  PopularArticles({Key key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final pb = context.watch<PopularBloc>();

    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 23,
                  width: 4,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(
                  width: 6,
                ),
                Text('popular news',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)).tr(),
                Spacer(),
                TextButton(
                  child: Text('view all', style: TextStyle(
                    color: Theme.of(context).primaryColorDark
                  ),).tr(),
                  onPressed: ()=> nextScreen(context, MoreArticles(title: 'popular news')),
                )
              ],
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          child: ListView.separated(
            padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: pb.data.isEmpty ? 2 : pb.data.length,
            separatorBuilder: (context, index) => SizedBox(height: 15,),
            itemBuilder: (BuildContext context, int index) {
              if (pb.data.isEmpty) return LoadingCard(height: 200);
              return Card1(d: pb.data[index], heroTag: 'popular$index',);
            },
          ),
        )
      ],
    );
  }
}

