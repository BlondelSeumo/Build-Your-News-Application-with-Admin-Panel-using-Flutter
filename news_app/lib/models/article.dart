import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Article {

  String category;
  String contentType;
  String title;
  String description;
  String thumbnailImagelUrl;
  String youtubeVideoUrl;
  String videoID;
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
    this.videoID,
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
      videoID: d['content type'] == 'video'? YoutubePlayer.convertUrlToId(d['youtube url'], trimWhitespaces: true) : '',
      loves: d['loves'],
      sourceUrl: d['source'],
      date: d['date'],
      timestamp: d['timestamp'], 


    );
  }
}