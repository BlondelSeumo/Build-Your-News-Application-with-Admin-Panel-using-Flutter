import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:news_app/blocs/categories_bloc.dart';
import 'package:news_app/models/category.dart';
import 'package:news_app/pages/category_based_articles.dart';
import 'package:news_app/utils/cached_image.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';



class Categories extends StatefulWidget {
  Categories({Key key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> with AutomaticKeepAliveClientMixin {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
    .then((value){
      controller = new ScrollController()..addListener(_scrollListener);
      context.read<CategoriesBloc>().getData(mounted);
    });

  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }




  void _scrollListener() {
    final db = context.read<CategoriesBloc>();
    
    if (!db.isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context.read<CategoriesBloc>().setLoading(true);
        context.read<CategoriesBloc>().getData(mounted);

      }
    }
  }



  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cb = context.watch<CategoriesBloc>();

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text(
            'categories'
            
          ).tr(),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Feather.rotate_cw, size: 22,),
              onPressed: (){
                context.read<CategoriesBloc>().onRefresh(mounted);
              },
            )
          ],
        ),

    body: RefreshIndicator(
        child: cb.hasData == false 
        ? ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.35,),
            EmptyPage(icon: Feather.clipboard, message: 'no categories found'.tr(), message1: ''),
          ],
          )
        
        : GridView.builder(
          controller: controller,
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.1
          ),
          itemCount: cb.data.length != 0 ? cb.data.length + 1 : 10,
          itemBuilder: (_, int index) {

            if (index < cb.data.length) {
              return _ItemList(d: cb.data[index]);
            }
            return Opacity(
                opacity: cb.isLoading ? 1.0 : 0.0,
                child: cb.lastVisible == null
                ? LoadingCard(height: null)
                
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
          context.read<CategoriesBloc>().onRefresh(mounted);
          
        },
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}




class _ItemList extends StatelessWidget {
  final CategoryModel d;
  const _ItemList({Key key, @required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
          child: Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0,3),
                color: Theme.of(context).shadowColor
              )
            ]
          
        ),
        child: Stack(
          children: [
            Hero(
                tag: 'category${d.timestamp}',
                child: Container(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ColorFiltered(
                    child: CustomCacheImage(imageUrl: d.thumbnailUrl, radius: 5.0),
                    colorFilter: ColorFilter.mode(Colors.grey[500], BlendMode.darken),
                  )
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, bottom: 15, right: 10),
                child: Text(d.name, style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600
                ),),
              ),
            )

            
          ],
        )
      ),

      onTap: (){
        nextScreen(context, CategoryBasedArticles(
          category: d.name,
          categoryImage: d.thumbnailUrl,
          tag: 'category${d.timestamp}',
        ));
      },

      
    );
  }
}
