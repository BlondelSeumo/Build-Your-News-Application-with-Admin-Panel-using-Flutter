import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/blocs/custom_notification_bloc.dart';
import 'package:news_app/cards/notification_card.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomNotifications extends StatefulWidget {
  const CustomNotifications({Key key}) : super(key: key);

  @override
  _CustomNotificationsState createState() => _CustomNotificationsState();
}

class _CustomNotificationsState extends State<CustomNotifications> {

  ScrollController controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
    .then((value){
      controller = new ScrollController()..addListener(_scrollListener);
      context.read<CustomNotificationBloc>().onRefresh(mounted);
    });

  }


  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }




  void _scrollListener() {
    final db = context.read<CustomNotificationBloc>();
    
    if (!db.isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        db.setLoading(true);
        db.getData(mounted);

      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final nb = context.watch<CustomNotificationBloc>();
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
          controller: controller,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: nb.data.length != 0 ? nb.data.length + 1 : 8,
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 15,),
          itemBuilder: (_, int index) {

            if (index < nb.data.length) {
              return NotificationCard(d: nb.data[index]);
            }
            return Opacity(
                opacity: nb.isLoading ? 1.0 : 0.0,
                child: nb.lastVisible == null
                ? LoadingCard(height: 150)
                
                : Center(
                  child: SizedBox(
                      width: 32.0,
                      height: 32.0,
                      child: new CupertinoActivityIndicator()),
                ),
              
            );
          },
        ),
        onRefresh: () async {
          context.read<CustomNotificationBloc>().onRefresh(mounted);
          
        },
      );
  }
}
