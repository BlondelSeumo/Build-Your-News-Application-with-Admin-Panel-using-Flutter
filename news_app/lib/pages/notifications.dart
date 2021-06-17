import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:news_app/blocs/article_notification_bloc.dart';
import 'package:news_app/blocs/custom_notification_bloc.dart';
import 'package:news_app/widgets/article_notifications.dart';
import 'package:news_app/widgets/custom_notifications.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';




class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {


  
  TabController _tabController;

  List<Tab> _tabs = [
    Tab(
      text: "custom notifications".tr(),
    ),
    Tab(
      text: 'news notifications'.tr(),
    ),
  
  ];






  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    

  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'notifications'
            
          ).tr(),
          elevation: 0,
          actions: <Widget>[
            
            IconButton(
              icon: Icon(Feather.rotate_cw, size: 22,),
              onPressed: ()async{
                _tabController.index == 0
                ? await context.read<CustomNotificationBloc>().onRefresh(mounted)
                : await context.read<ArticleNotificationBloc>().onRefresh(mounted);

              },
            )
          ],
          bottom: TabBar(
                  labelStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Color(0xff5f6368), //niceish grey
                  isScrollable: false,
                  

                  onTap: (index) {
                    //_tabController.animateTo(index);
                  },
                  indicator: MD2Indicator(
                    //it begins here
                    indicatorHeight: 2,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorSize: MD2IndicatorSize.normal,
                  ),
                  tabs: _tabs,
                ),
        ),

    body: TabBarView(
      controller: _tabController,
      children: [
        CustomNotifications(),
        ArticleNotifications()
        
      ],
    )
    );
  }
}



















