import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';

class RecentBloc extends ChangeNotifier{
  
  List<Article> _data = [];
  List<Article> get data => _data;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _snap = [];

  DocumentSnapshot _lastVisible;
  DocumentSnapshot get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;


  Future<Null> getData(mounted) async {
    QuerySnapshot rawData;
    
    if (_lastVisible == null)
      rawData = await firestore
          .collection('contents')
          .orderBy('timestamp', descending: true)
          .limit(4)
          .get();
    else
      rawData = await firestore
          .collection('contents')
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible['timestamp']])
          .limit(4)
          .get();





    if (rawData != null && rawData.docs.length > 0) {
      _lastVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted) {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _data = _snap.map((e) => Article.fromFirestore(e)).toList();
        notifyListeners();
      }
    } else {
      _isLoading = false;
      print('no items available');
      notifyListeners();
      
    }
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

  


  // Future getData() async {
  //   QuerySnapshot rawData;
  //     rawData = await firestore
  //         .collection('places')
  //         .orderBy('timestamp', descending: true)
  //         .limit(10)
  //         .get();
      
  //     List<DocumentSnapshot> _snap = [];
  //     _snap.addAll(rawData.docs);
  //     _data = _snap.map((e) => Article.fromFirestore(e)).toList();
  //     notifyListeners();
    
    
  // }

  // onRefresh(mounted) {
  //   _data.clear();
  //   getData();
  //   notifyListeners();
  // }





}