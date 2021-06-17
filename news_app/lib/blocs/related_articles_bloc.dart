
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:news_app/models/article.dart';

class RelatedBloc extends ChangeNotifier{
  
  List<Article> _data = [];
  List<Article> get data => _data;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
 

  Future getData(String category, String timestamp) async {
    _data.clear();
    QuerySnapshot rawData;
      rawData = await firestore
          .collection('contents')
          .where('category', isEqualTo: category)
          .where('timestamp', isNotEqualTo: timestamp)
          .orderBy('timestamp')
          .limit(5)
          .get();
      
      List<DocumentSnapshot> _snap = [];
      _snap.addAll(rawData.docs);
      _data = _snap.map((e) => Article.fromFirestore(e)).toList();
      notifyListeners();
    
    
  }

  onRefresh(mounted, String stateName, String timestamp) {
    _data.clear();
    getData(stateName, timestamp);
    notifyListeners();
  }




}