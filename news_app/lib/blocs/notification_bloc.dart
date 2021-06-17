import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:news_app/pages/notifications.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';




class NotificationBloc extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final String subscriptionTopic = 'all';

  

  bool _subscribed;
  bool get subscribed => _subscribed;

  int _notificationLength = 0;
  int get notificationLength => _notificationLength;
  
  int _savedNlength = 0;
  int get savedNlength => _savedNlength;

  int _notificationFinalLength = 0;
  int get notificationFinalLength => _notificationFinalLength;






  Future handleNotificationlength () async{
    await getNlengthFromSP().then((value){
      getNotificationLengthFromDatabase().then((_length){
        _notificationLength = _length;
        _notificationFinalLength = _notificationLength - savedNlength;
        notifyListeners();

      });
    });

  }



  Future<int> getNotificationLengthFromDatabase () async {
    final DocumentReference ref = firestore.collection('item_count').doc('notifications_count');
      DocumentSnapshot snap = await ref.get();
      if(snap.exists == true){
        int itemlength = snap['count'] ?? 0;
        return itemlength;
      }
      else{
        return 0;
      }
  }



  
  
  Future getNlengthFromSP () async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int _savedLength = sp.get('saved length') ?? 0;
    _savedNlength = _savedLength;
    notifyListeners();
  }


  Future saveNlengthToSP () async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('saved length', _notificationLength);
    _savedNlength = _notificationLength;
    handleNotificationlength();
    notifyListeners();
  }






  

  Future initFirebasePushNotification(context) async {
    if (Platform.isIOS) {
      _fcm.onIosSettingsRegistered.listen((event) {
        print('event: $event');
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    handleFcmSubscribtion();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showinAppDialog(context, message['notification']['title'], message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        nextScreen(context, NotificationsPage());
      },
      onResume: (Map<String, dynamic> message) async {
        handleNotificationlength();
        print("onResume: $message");
      },
    );

    notifyListeners();
  }






  Future handleFcmSubscribtion() async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool _getsubcription = sp.getBool('subscribe') ?? true;
    if(_getsubcription == true){
      await sp.setBool('subscribe', true);
      _fcm.subscribeToTopic(subscriptionTopic);
      _subscribed = true;
      print('subscribed');
    }else{
      await sp.setBool('subscribe', false);
      _fcm.unsubscribeFromTopic(subscriptionTopic);
      _subscribed = false;
      print('unsubscribed');
    }
    
    notifyListeners();
  }








  Future fcmSubscribe(bool isSubscribed) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('subscribe', isSubscribed);
    handleFcmSubscribtion();
  }

  







  showinAppDialog(context, title, body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(title),
          subtitle: HtmlWidget(body),
        ),
        actions: <Widget>[
          TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                nextScreen(context, NotificationsPage());
              }),
        ],
      ),
    );
  }
}