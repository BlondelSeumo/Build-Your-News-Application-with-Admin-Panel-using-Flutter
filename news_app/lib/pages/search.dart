import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:news_app/blocs/search_bloc.dart';
import 'package:news_app/cards/card4.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:news_app/utils/snacbar.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';



class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0))
    .then((value) => context.read<SearchBloc>().saerchInitialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: _searchBar(),
      ),
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // suggestion text

            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 15, bottom: 5, right: 15),
              child: Text(
                context.watch<SearchBloc>().searchStarted == false
                    ? 'recent searchs'
                    : 'we have found',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ).tr(),
            ),
            context.watch<SearchBloc>().searchStarted == false
                ? SuggestionsUI()
                : AfterSearchUI()
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: TextFormField(
        autofocus: true,
        controller: context.watch<SearchBloc>().textfieldCtrl,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "search news".tr(),
          hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).secondaryHeaderColor),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
              size: 25,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              context.read<SearchBloc>().saerchInitialize();
            },
          ),
        ),
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value) {
          if (value == '') {
            openSnacbar(scaffoldKey, 'Type something!');
          } else {
            context.read<SearchBloc>().setSearchText(value);
            context.read<SearchBloc>().addToSearchList(value);
          }
        },
      ),
    );
  }
}

class SuggestionsUI extends StatelessWidget {
  const SuggestionsUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SearchBloc>();
    return Expanded(
      child: sb.recentSearchData.isEmpty
          ? EmptyPage(
              icon: Feather.search,
              message: 'search news'.tr(),
              message1: "search-description".tr(),
            )
          : ListView.separated(
              padding: EdgeInsets.all(15),
              itemCount: sb.recentSearchData.length,
              separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: ListTile(
                    title: Text(
                      sb.recentSearchData[index],
                      style: TextStyle(fontSize: 17),
                    ),
                    leading: Icon(
                      CupertinoIcons.time_solid,
                      color: Colors.grey[400],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        context
                            .read<SearchBloc>()
                            .removeFromSearchList(sb.recentSearchData[index]);
                      },
                    ),
                    onTap: () {
                      context
                          .read<SearchBloc>()
                          .setSearchText(sb.recentSearchData[index]);
                    },
                  ),
                );
              },
            ),
    );
  }
}

class AfterSearchUI extends StatelessWidget {
  const AfterSearchUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: context.watch<SearchBloc>().getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return EmptyPage(
                icon: Feather.clipboard,
                message: 'no articles found'.tr(),
                message1: "try again".tr(),
              );
            else
              return ListView.separated(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: 15,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Card4(
                      d: snapshot.data[index], heroTag: 'search$index');
                },
              );
          }
          return ListView.separated(
            padding: EdgeInsets.all(15),
            itemCount: 10,
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 15,
            ),
            itemBuilder: (BuildContext context, int index) {
              return LoadingCard(height: 120);
            },
          );
        },
      ),
    );
  }
}
