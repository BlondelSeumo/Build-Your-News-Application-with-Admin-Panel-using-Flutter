import 'package:flutter/material.dart';

class CoverWidget extends StatelessWidget {
  final widget;
  const CoverWidget({Key key, @required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        padding: EdgeInsets.only(
          left: w * 0.05,
          right: w * 0.20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey[300], blurRadius: 10, offset: Offset(3, 3))
          ],
        ),
        child: widget

    );
  }
}