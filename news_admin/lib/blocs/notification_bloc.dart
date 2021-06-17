import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:news_admin/config/config.dart';
import '../utils/toast.dart';

class NotificationBloc extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  

  Future sendNotification (String title) async{
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${Config().serverToken}',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Click here to read more details',
            'title': title
          },
          'priority': 'normal',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': "/topics/all",
        },
      ),
    );
  }



  Future saveToDatabase(String timestamp, String title, String description, String date) async {
    final DocumentReference ref = FirebaseFirestore.instance.collection('notifications').doc('custom').collection('list').doc(timestamp);
    await ref.set({
      
      'title': title,
      'description': description,
      'date': date,
      'timestamp': timestamp,
      
    });
  }


  Future<List> getNotificationsList ()async{
    final DocumentReference ref = firestore.collection('notifications').doc('contents');
      DocumentSnapshot snap = await ref.get();
      if(snap.exists == true){
        List featuredList = snap['list'] ?? [];
        return featuredList;
      }
      else{
        await ref.set({
          'list' : []
        });
        return [];
      }
  }



  Future addToNotificationList (context, String timestamp) async {
    final DocumentReference ref = firestore.collection('notifications').doc('contents');
    await getNotificationsList().then((list)async{

      if (list.contains(timestamp)) {
        openToast1(context, "This item is already available in the featured list");
      } else {

        list.add(timestamp);
        await ref.update({'list': FieldValue.arrayUnion(list)});
        openToast1(context, 'Added Successfully');
      }
    });
  }



  Future removeFromNotificationList (context, String timestamp) async {
    final DocumentReference ref = firestore.collection('notifications').doc('contents');
    await getNotificationsList().then((list)async{

      if (list.contains(timestamp)) {
        await ref.update({'list' : FieldValue.arrayRemove([timestamp])});
        openToast1(context, 'Removed Successfully');
      }
    });
  }


  Future deleteCustomNotification (String timestamp) async {
    await firestore.collection('notifications').doc('custom')
    .collection('list').doc(timestamp).delete();
  }

  

  Future<List> getContentNotificationsList ()async{
    final DocumentReference ref = firestore.collection('notifications').doc('contents');
      DocumentSnapshot snap = await ref.get();
      if(snap.exists == true){
        List list = snap['list'] ?? [];
        return list;
      }
      else{
        await ref.set({
          'list' : []
        });
        return [];
      }
  }



  




}
