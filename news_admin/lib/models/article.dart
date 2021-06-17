import 'package:cloud_firestore/cloud_firestore.dart';

class Article {

  String category;
  String contentType;
  String title;
  String description;
  String thumbnailImagelUrl;
  String youtubeVideoUrl;
  int loves;
  String sourceUrl;
  String date;
  String timestamp;

  Article({
    
    this.category,
    this.contentType,
    this.title,
    this.description,
    this.thumbnailImagelUrl,
    this.youtubeVideoUrl,
    this.loves,
    this.sourceUrl,
    this.date,
    this.timestamp
    
  });


  factory Article.fromFirestore(DocumentSnapshot snapshot){
    var d = snapshot.data();
    return Article(
      category: d['category'],
      contentType: d['content type'],
      title: d['title'],
      description: d['description'],
      thumbnailImagelUrl: d['image url'],
      youtubeVideoUrl: d['youtube url'],
      loves: d['loves'],
      sourceUrl: d['source'],
      date: d['date'],
      timestamp: d['timestamp'], 


    );
  }
}