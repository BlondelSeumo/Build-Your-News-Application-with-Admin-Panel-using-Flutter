
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {

  String uid;
  String name;
  String imageUrl;
  String comment;
  String date;
  String timestamp;

  Comment({
    this.uid,
    this.name,
    this.imageUrl,
    this.comment,
    this.date,
    this.timestamp
    
  });


  factory Comment.fromFirestore(DocumentSnapshot snapshot){
    var d = snapshot.data();
    return Comment(
      uid: d['uid'],
      name: d['name'],
      imageUrl: d['image url'],
      comment: d['comment'],
      date: d['date'],
      timestamp: d['timestamp'], 


    );
  }
}