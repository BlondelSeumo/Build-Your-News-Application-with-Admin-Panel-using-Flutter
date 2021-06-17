import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LoveCount extends StatelessWidget {
  final String collectionName;
  final String timestamp;
  const LoveCount({Key key, @required this.collectionName, @required this.timestamp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.favorite,
          color: Colors.grey[500],
          size: 18,
        ),
        SizedBox(
          width: 2,
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName)
              .doc(timestamp)
              .snapshots(),
          builder: (context, AsyncSnapshot snap) {
            if (!snap.hasData)
              return Text(
                0.toString(),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              );
            return Text(
              snap.data['loves'].toString(),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            );
          },
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          'people like this',
          maxLines: 1,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
        ).tr()
      ],
    );
  }
}
