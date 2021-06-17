import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  String thumbnailUrl;
  String timestamp;

  Category({
    this.name,
    this.thumbnailUrl,
    this.timestamp
  });


  factory Category.fromFirestore(DocumentSnapshot snapshot){
    var d = snapshot.data();
    return Category(
      name: d['name'],
      thumbnailUrl: d['thumbnail'],
      timestamp: d['timestamp'],
    );
  }
}