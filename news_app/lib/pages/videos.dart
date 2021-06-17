import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:news_app/blocs/videos_bloc.dart';
import 'package:news_app/cards/card4.dart';
import 'package:news_app/cards/card5.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class VideoArticles extends StatefulWidget {
  VideoArticles({Key key}) : super(key: key);

  @override
  _VideoArticlesState createState() => _VideoArticlesState();
}

class _VideoArticlesState extends State<VideoArticles> with AutomaticKeepAliveClientMixin {



  ScrollController controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _orderBy = 'timestamp';



  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
    .then((value){
      controller = new ScrollController()..addListener(_scrollListener);
      context.read<VideosBloc>().getData(mounted, _orderBy);
    });

  }


  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }




  void _scrollListener() {
    final db = context.read<VideosBloc>();
    
    if (!db.isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context.read<VideosBloc>().setLoading(true);
        context.read<VideosBloc>().getData(mounted, _orderBy);

      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final vb = context.watch<VideosBloc>();

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text(
            'video articles'
            
          ).tr(),
          elevation: 0,
          actions: <Widget>[
            PopupMenuButton(
                child: Icon(CupertinoIcons.sort_down),
                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem>[
                    PopupMenuItem(
                      child: Text('most recent').tr(),
                      value: 'recent',
                    ),
                    PopupMenuItem(
                      child: Text('most popular').tr(),
                      value: 'popular',
                    )
                  ];
                },
                onSelected: (value) {
                  setState(() {
                    if(value == 'popular'){
                      _orderBy = 'loves';
                    }else{
                      _orderBy = 'timestamp';
                    }
                  });
                  vb.afterPopSelection(value, mounted, _orderBy);
                }),
            IconButton(
              icon: Icon(Feather.rotate_cw, size: 22,),
              onPressed: ()async {
                context.read<VideosBloc>().onRefresh(mounted, _orderBy);
              },
            )
          ],
        ),

    body: RefreshIndicator(
        child: vb.hasData == false 
        ? ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.35,),
            EmptyPage(icon: Feather.clipboard, message: 'no articles found'.tr(), message1: ''),
          ],
          )
        
        : ListView.separated(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          controller: controller,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: vb.data.length != 0 ? vb.data.length + 1 : 5,
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 15,),
          
          //shrinkWrap: true,
          itemBuilder: (_, int index) {

            if (index < vb.data.length) {
              if(index.isOdd) return Card4(d: vb.data[index], heroTag: 'video$index');
              else return Card5(d: vb.data[index], heroTag: 'video$index',);
            }
            return Opacity(
                opacity: vb.isLoading ? 1.0 : 0.0,
                child: vb.lastVisible == null
                ? LoadingCard(height: 250)
                
                
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
          context.read<VideosBloc>().onRefresh(mounted, _orderBy);
          
        },
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


