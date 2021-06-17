import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsBloc extends ChangeNotifier{

  
  String date;
  String newTimestamp;

  List<String> _flagList = [];
  List<String> get flagList => _flagList;

  final String _collectionName = 'contents';
  

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  

  Future saveNewComment(String timestamp, String newComment) async{

    final SharedPreferences sp = await SharedPreferences.getInstance();
    String _name = sp.getString('name');
    String _uid = sp.getString('uid');
    String _imageUrl = sp.getString('image_url');

    await _getDate()
    .then((value) => firestore
       .collection('$_collectionName/$timestamp/comments')
       .doc('$_uid$newTimestamp').set({
        'name': _name,
        'comment' : newComment,
        'date' : date,
        'image url' : _imageUrl,
        'timestamp': newTimestamp,
        'uid' : _uid
       }));
    
    
    notifyListeners();

  }





  Future deleteComment (String timestamp, String uid, String timestamp2, ) async{

    await firestore.collection('$_collectionName/$timestamp/comments').doc('$uid$timestamp2').delete();
    notifyListeners();
  }





  Future _getDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat('dd MMMM yy').format(now);
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    date = _date;
    newTimestamp = _timestamp;
  }



  Future getFlagList () async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _flagList = sp.getStringList('flag_list') ?? [];
    notifyListeners();
  }


  Future addToFlagList (context, String commentsDocumentName)async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await getFlagList().then((value)async{
      List<String> a = _flagList;
      if(a.contains(commentsDocumentName)){
        openToast1(context, 'You have flagged this comment already');
      }else{
        a.add(commentsDocumentName);
        await sp.setStringList('flag_list', a);
      }
      
    });
  }


  Future removeFromFlagList (context, String commentsDocumentName)async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await getFlagList().then((value)async{
      List<String> a = _flagList;
      if(a.contains(commentsDocumentName)){
        a.remove(commentsDocumentName);
        await sp.setStringList('flag_list', a);
      }else{
        print('not possible');
      }
      
    });
  }


  Future reportComment (String postDocumentName, String uid, String commnetTimestamp) async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String _reporterUId = sp.getString('uid');
    final String _documentName = 'comments_report';
    final String _commentDocumentName = '$uid$commnetTimestamp';


    final CollectionReference ref = firestore.collection('user_reports').doc(_documentName).collection('reported_list');
    await _getDate().then((value)async{
      await ref.add({
      'post_document': postDocumentName,
      'reporter_uid' : _reporterUId,
      'reported_uid' : uid,
      'reported_at' : DateTime.now(),
      'reported_document' : _commentDocumentName,
      'timestamp' : newTimestamp
    });
    });
    
  }


}