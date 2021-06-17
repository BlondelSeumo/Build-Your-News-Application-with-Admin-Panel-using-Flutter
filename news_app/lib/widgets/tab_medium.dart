
import 'package:flutter/material.dart';
import 'package:news_app/blocs/category_tab1_bloc.dart';
import 'package:news_app/blocs/category_tab2_bloc.dart';
import 'package:news_app/blocs/category_tab3_bloc.dart';
import 'package:news_app/blocs/category_tab4_bloc.dart';
import 'package:news_app/blocs/recent_articles_bloc.dart';
import 'package:news_app/blocs/tab_index_bloc.dart';
import 'package:news_app/config/config.dart';
import 'package:news_app/tabs/category_tab1.dart';
import 'package:news_app/tabs/category_tab2.dart';
import 'package:news_app/tabs/category_tab3.dart';
import 'package:news_app/tabs/category_tab4.dart';
import 'package:news_app/tabs/tab0.dart';
import 'package:provider/provider.dart';



class TabMedium extends StatefulWidget {
  final ScrollController sc;
  final TabController tc;
  TabMedium({Key key, this.sc, this.tc}) : super(key: key);

  @override
  _TabMediumState createState() => _TabMediumState();
}

class _TabMediumState extends State<TabMedium> {
  
  @override
  void initState() {
    super.initState();
    this.widget.sc.addListener(_scrollListener);
  }



  void _scrollListener() {
      final db = context.read<RecentBloc>();
      final cb1 = context.read<CategoryTab1Bloc>();
      final cb2 = context.read<CategoryTab2Bloc>();
      final cb3 = context.read<CategoryTab3Bloc>();
      final cb4 = context.read<CategoryTab4Bloc>();
      final sb = context.read<TabIndexBloc>();

      if (sb.tabIndex == 0) {
        if (!db.isLoading) {
          if (this.widget.sc.offset >= this.widget.sc.position.maxScrollExtent && !this.widget.sc.position.outOfRange) {
            print("reached the bottom");
            db.setLoading(true);
            db.getData(mounted);
          }
        }
      } 
      else if(sb.tabIndex == 1){
        if (!cb1.isLoading) {
          if (this.widget.sc.offset >= this.widget.sc.position.maxScrollExtent && !this.widget.sc.position.outOfRange) {
            print("reached the bottom -t1");
            cb1.setLoading(true);
            cb1.getData(mounted, Config().initialCategories[0],);
          }
        }
      }
      else if(sb.tabIndex == 2){
        if (!cb2.isLoading) {
          if (this.widget.sc.offset >= this.widget.sc.position.maxScrollExtent && !this.widget.sc.position.outOfRange) {
            print("reached the bottom -t2");
            cb2.setLoading(true);
            cb2.getData(mounted, Config().initialCategories[1],);
          }
        }
      }
      else if(sb.tabIndex == 3){
        if (!cb3.isLoading) {
          if (this.widget.sc.offset >= this.widget.sc.position.maxScrollExtent && !this.widget.sc.position.outOfRange) {
            print("reached the bottom -t3");
            cb3.setLoading(true);
            cb3.getData(mounted, Config().initialCategories[2],);
          }
        }
      }
      else if(sb.tabIndex == 4){
        if (!cb4.isLoading) {
          if (this.widget.sc.offset >= this.widget.sc.position.maxScrollExtent && !this.widget.sc.position.outOfRange) {
            print("reached the bottom -t4");
            cb4.setLoading(true);
            cb4.getData(mounted, Config().initialCategories[3],);
          }
        }
      }
    
  }



  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        Tab0(),
        CategoryTab1(
          category: Config().initialCategories[0],
        ),
        CategoryTab2(
          category: Config().initialCategories[1],

        ),
        CategoryTab3(
          category: Config().initialCategories[2],
        ),
        CategoryTab4(
          category: Config().initialCategories[3],
        ),
      ],
      controller: widget.tc,
    );
  }
}