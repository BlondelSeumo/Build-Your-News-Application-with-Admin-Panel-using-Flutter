import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/blocs/article_notification_bloc.dart';
import 'package:news_app/cards/card4.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ArticleNotifications extends StatefulWidget {
  const ArticleNotifications({Key key}) : super(key: key);

  @override
  _ArticleNotificationsState createState() => _ArticleNotificationsState();
}

class _ArticleNotificationsState extends State<ArticleNotifications> {

  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
    .then((value){
      context.read<ArticleNotificationBloc>().onRefresh(mounted);
    });

  }



  @override
  Widget build(BuildContext context) {
    final nb = context.watch<ArticleNotificationBloc>();
    return RefreshIndicator(
        child: nb.hasData == false 
        ? ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.35,),
            EmptyPage(icon: LineIcons.bell_slash, message: 'no notification'.tr(), message1: ''),
          ],
          )
        
        : ListView.separated(
          padding: EdgeInsets.all(15),
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: nb.data.length != 0 ? nb.data.length + 1 : 8,
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 15,),
          itemBuilder: (_, int index) {

            if (index < nb.data.length) {
              return Card4(d: nb.data[index], heroTag: 'notification$index');
            }
            return Opacity(
                opacity: nb.isLoading ? 1.0 : 0.0,
                child: LoadingCard(height: 180)
                
            );
          },
        ),
        onRefresh: () async {
          context.read<ArticleNotificationBloc>().onRefresh(mounted);
          
        },
      );
  }
}
