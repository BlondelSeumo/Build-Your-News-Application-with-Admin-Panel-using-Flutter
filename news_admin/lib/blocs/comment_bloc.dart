import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CommentBloc extends ChangeNotifier{


  String newTimestamp;
  String date;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  

  Future saveNewComment(String timestamp, String newComment) async{

    String _uid = 'admin'; // admin uid
    String _adminName = 'Admin'; //admin name
    String _imageUrl = 'https://img.icons8.com/bubbles/2x/admin-settings-male.png';  //admin icon url

    await _getDate()
    .then((value) => firestore
       .collection('contents/$timestamp/comments')
       .doc('$_uid$newTimestamp').set({
        'uid' : _uid,
        'name' : _adminName,
        'image url' : _imageUrl,
        'comment' : newComment,
        'date' : date,
        'timestamp' : newTimestamp
       }));
    notifyListeners();

  }




  Future deleteComment (String timestamp, String uid, String timestamp2) async{
    await firestore.collection('contents/$timestamp/comments').doc('$uid$timestamp2').delete();
    notifyListeners();
  }





  


  Future _getDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat('dd MMMM yy').format(now);
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    date = _date;
    newTimestamp = _timestamp;
  }





}