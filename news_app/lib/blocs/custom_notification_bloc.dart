
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/notification.dart';




class CustomNotificationBloc extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentSnapshot _lastVisible;
  DocumentSnapshot get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<DocumentSnapshot> _snap = [];

  List<NotificationModel> _data = [];
  List<NotificationModel> get data => _data;

  bool _hasData;
  bool get hasData => _hasData;




  Future<Null> getData(mounted) async {
    _hasData = true;
    QuerySnapshot rawData;
    
    if (_lastVisible == null)
      rawData = await firestore
          .collection('notifications')
          .doc('custom')
          .collection('list')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();
    else
      rawData = await firestore
          .collection('notifications')
          .doc('custom')
          .collection('list')
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible['timestamp']])
          .limit(5)
          .get();





    if (rawData != null && rawData.docs.length > 0) {
      _lastVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted) {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _data = _snap.map((e) => NotificationModel.fromFirestore(e)).toList();
      }
    } else {

      if(_lastVisible == null){

        _isLoading = false;
        _hasData = false;
        print('no items');

      }else{
        _isLoading = false;
        _hasData = true;
        print('no more items');
      }
      
    }

    notifyListeners();
    return null;
  }







  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }




  onRefresh(mounted) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _lastVisible = null;
    getData(mounted);
    notifyListeners();
  }





  

  
}