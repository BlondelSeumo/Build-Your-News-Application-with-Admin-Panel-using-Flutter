import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';

class VideosBloc extends ChangeNotifier {

  DocumentSnapshot _lastVisible;
  DocumentSnapshot get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Article> _data = [];
  List<Article> get data => _data;

  String _popSelection = 'recent';
  String get popupSelection => _popSelection;


  List<DocumentSnapshot> _snap = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  bool _hasData;
  bool get hasData => _hasData;




  Future<Null> getData(mounted, String orderBy) async {
    _hasData = true;
    QuerySnapshot rawData;
    
    if (_lastVisible == null)
      rawData = await firestore
          .collection('contents')
          .where('content type', isEqualTo: 'video')
          .orderBy(orderBy, descending: true)
          .limit(6)
          .get();
    else
      rawData = await firestore
          .collection('contents')
          .where('content type', isEqualTo: 'video')
          .orderBy(orderBy, descending: true)
          .startAfter([_lastVisible[orderBy]])
          .limit(6)
          .get();





    if (rawData != null && rawData.docs.length > 0) {
      _lastVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted) {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _data = _snap.map((e) => Article.fromFirestore(e)).toList();
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


  afterPopSelection (value, mounted, orderBy){
    _popSelection = value;
    onRefresh(mounted, orderBy);
    notifyListeners();
  }



  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }




  onRefresh(mounted, orderBy) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _lastVisible = null;
    getData(mounted, orderBy);
    notifyListeners();
  }


}