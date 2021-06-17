import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:news_app/blocs/category_tab1_bloc.dart';
import 'package:news_app/cards/card1.dart';
import 'package:news_app/cards/card2.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:provider/provider.dart';

class CategoryTab1 extends StatefulWidget {
  final String category;
  CategoryTab1({Key key, @required this.category}) : super(key: key);

  @override
  _CategoryTab1State createState() => _CategoryTab1State();
}

class _CategoryTab1State extends State<CategoryTab1> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if(this.mounted){
      context.read<CategoryTab1Bloc>().data.isNotEmpty ? print('data already loaded'):
      context.read<CategoryTab1Bloc>().getData(mounted, widget.category);
    }
    
  }




  @override
  Widget build(BuildContext context) {
    final cb = context.watch<CategoryTab1Bloc>();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CategoryTab1Bloc>().onRefresh(mounted, widget.category);
      },
      child: cb.hasData == false
          ? ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
                EmptyPage(
                    icon: Feather.clipboard,
                    message: 'No articles found',
                    message1: ''),
              ],
            )
          : ListView.separated(
              key: PageStorageKey(widget.category),
              padding: EdgeInsets.all(15),
              physics: NeverScrollableScrollPhysics(),
              itemCount: cb.data.length != 0 ? cb.data.length + 1 : 5,
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: 15,
              ),
              shrinkWrap: true,
              itemBuilder: (_, int index) {
                if (index < cb.data.length) {
                  if(index %2 == 0 && index != 0) return Card1(d: cb.data[index], heroTag: 'tab1$index');
                  return Card2(d: cb.data[index], heroTag: 'tab1$index');
                }
                return Opacity(
                  opacity: cb.isLoading ? 1.0 : 0.0,
                  child: cb.lastVisible == null
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
    );
  }
}
