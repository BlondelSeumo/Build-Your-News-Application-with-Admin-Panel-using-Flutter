import 'package:flutter/material.dart';

class VideoIcon extends StatelessWidget {
  final String contentType;
  final double iconSize;
  const VideoIcon({Key key, @required this.contentType, this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (contentType != 'video')
      return Container();
    else
      return Align(
        child: Icon(Icons.play_circle_fill_outlined,
            color: Colors.white, size: iconSize),
      );
  }
}
