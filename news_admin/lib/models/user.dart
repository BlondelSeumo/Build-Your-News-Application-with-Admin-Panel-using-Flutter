import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userName;
  String userEmail;
  String imageUrl;
  String uid;
  String joiningDate;
  String timestamp;

  User({
    this.userName,
    this.userEmail,
    this.imageUrl,
    this.uid,
    this.joiningDate,
    this.timestamp
  });


  factory User.fromFirestore(DocumentSnapshot snapshot){
    var d = snapshot.data();
    return User(
      userName: d['name'] ?? '',
      userEmail: d['email'] ?? '',
      imageUrl: d['image url'] ?? 'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png',
      uid: d['uid'] ?? '',
      joiningDate: d['joining date'] ?? '',
      timestamp: d['timestamp']
    );
  }
}