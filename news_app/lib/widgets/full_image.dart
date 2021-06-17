
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreeImage extends StatelessWidget {
  final String imageUrl;
  const FullScreeImage({Key key, @required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: InteractiveViewer(
            child: Image(image: CachedNetworkImageProvider(imageUrl)),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.close, color: Colors.white,),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
        )
      ],
    ));
  }
}