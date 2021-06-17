
import 'package:flutter/material.dart';
import 'package:news_admin/blocs/admin_bloc.dart';
import 'package:provider/provider.dart';

class DataInfoPage extends StatefulWidget {
  const DataInfoPage({Key key}) : super(key: key);

  @override
  _DataInfoPageState createState() => _DataInfoPageState();
}

class _DataInfoPageState extends State<DataInfoPage> {

  Future users;
  Future contents;
  Future notifications;
  Future categories;
  Future featuredItems;


  initData () async {
    users = context.read<AdminBloc>().getTotalDocuments('users_count');
    contents = context.read<AdminBloc>().getTotalDocuments('contents_count');
    notifications = context.read<AdminBloc>().getTotalDocuments('notifications_count');
    categories = context.read<AdminBloc>().getTotalDocuments('categories_count');
    featuredItems = context.read<AdminBloc>().getTotalDocuments('featured_count');
  }

  @override
  void initState() {
    super.initState();
    initData();
    
  }



  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05, top: w * 0.05),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              FutureBuilder(
                future: users,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (!snap.hasData) return card('TOTAL USERS', 0);
                  if (snap.hasError) return card('TOTAL USERS', 0);
                  return card('TOTAL USERS', snap.data);
                },
              ),
              SizedBox(
                width: 20,
              ),
              FutureBuilder(
                future: contents,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (!snap.hasData) return card('TOTAL ARTICLES', 0);
                  if (snap.hasError) return card('TOTAL ARTICLES', 0);
                  return card('TOTAL ARTICLES', snap.data);
                },
              ),

              SizedBox(
                width: 20,
              ),

              FutureBuilder(
                future: featuredItems,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (!snap.hasData) return card('FEATURED ITEMS', 0);
                  if (snap.hasError) return card('FEATURED ITEMS', 0);
                  return card('FEATURED ITEMS', snap.data);
                },
              ),

              
              
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder(
                future: notifications,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (!snap.hasData) return card('TOTAL NOTIFICATIONS', 0);
                  if (snap.hasError) return card('TOTAL NOTIFICATIONS', 0);
                  return card('TOTAL NOTIFICATIONS', snap.data);
                },
              ),

              


              SizedBox(
                width: 20,
              ),
              FutureBuilder(
                future: categories,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (!snap.hasData) return card('TOTAL CATEGORIES', 0);
                  if (snap.hasError) return card('TOTAL CATEGORIES', 0);
                  return card('TOTAL CATEGORIES', snap.data);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget card(String title, int number) {
    return Container(
      padding: EdgeInsets.all(30),
      height: 180,
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey[300], blurRadius: 10, offset: Offset(3, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            height: 2,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.indigoAccent,
                borderRadius: BorderRadius.circular(15)),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.trending_up,
                size: 40,
                color: Colors.deepPurpleAccent,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                number.toString(),
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87),
              )
            ],
          )
        ],
      ),
    );
  }
}
