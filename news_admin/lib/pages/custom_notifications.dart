import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_admin/blocs/admin_bloc.dart';
import 'package:news_admin/blocs/notification_bloc.dart';
import 'package:news_admin/config/config.dart';
import 'package:news_admin/models/notification.dart';
import 'package:news_admin/utils/dialog.dart';
import 'package:news_admin/utils/toast.dart';
import 'package:provider/provider.dart';

import '../utils/styles.dart';

class CustomNotifications extends StatefulWidget {
  CustomNotifications({Key key}) : super(key: key);

  @override
  _CustomNotificationsState createState() => _CustomNotificationsState();
}

class _CustomNotificationsState extends State<CustomNotifications> {
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<NotificationModel> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final collectionName = 'notifications';



  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    if(this.mounted){
      _getData();

    }
  }





  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection(collectionName).doc('custom').collection('list')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
    else
      data = await firestore
          .collection(collectionName).doc('custom').collection('list')
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible['timestamp']])
          .limit(10)
          .get();

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => NotificationModel.fromFirestore(e)).toList();
        });
      }
    } else {
      setState(() => _isLoading = false);
      openToast(context, 'No more contents available!');
    }
    return null;
  }




  

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }




  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }





  refreshData (){
    setState(() {
      _isLoading = true;
      _data.clear();
      _snap.clear();
      _lastVisible = null;
    });
    _getData();
  }



  handleDelete(NotificationModel d) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
          contentPadding: EdgeInsets.all(50),
          elevation: 0,
          children: <Widget>[
            Text('Delete?',
                
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900)),
            SizedBox(
              height: 10,
            ),
            Text('Want to delete this item from the database?',
                
                style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Row(
                children: <Widget>[
                  TextButton(
                style: buttonStyle(Colors.redAccent),
                child: Text(
                  'Yes',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: ()async{
                  
                  
                  if (ab.userType == 'tester') {
                    Navigator.pop(context);
                    openDialog(context, 'You are a Tester','Only admin can delete contents');
                  } else {
                    await context.read<NotificationBloc>().deleteCustomNotification(d.timestamp)
                    .then((value) => ab.decreaseCount('notifications_count'))
                    .then((value) => openToast1(context, 'Deleted Successfully'));
                    refreshData();
                    Navigator.pop(context);
                    

                  }
                },
              ),

              SizedBox(width: 10),

              TextButton(
                style: buttonStyle(Colors.deepPurpleAccent),
                child: Text(
                  'No',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () => Navigator.pop(context),
              ),
                ],
              )
            )
          ],
        );
         
        });
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 30, bottom: 20),
              controller: controller,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _data.length + 1,
              itemBuilder: (_, int index) {
                if (index < _data.length) {
                  return dataList(_data[index]);
                }
                return Center(
                  child: new Opacity(
                    opacity: _isLoading ? 1.0 : 0.0,
                    child: new SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: new CircularProgressIndicator()),
                  ),
                );
              },
            ),
            onRefresh: () async {
              refreshData();

                    
            },
          
    );
  }





  

  Widget dataList(NotificationModel d) {
    return Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]),
              borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(Config().icon)),
            title: Text(d.title, style:TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(d.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style:TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 2),
                    Text(d.date, style:TextStyle(fontSize: 13, fontWeight: FontWeight.w400),),
                  ],
                )
              ],
            ),
            isThreeLine: true,
            trailing: InkWell(
               child: Container(
                        height: 35,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.delete,
                                    size: 16, color: Colors.grey[800])),
                            onTap: (){
                              handleDelete(d);
                            }),
                          ),
          
          
          );
  }
}