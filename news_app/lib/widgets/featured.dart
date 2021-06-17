import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/featured_bloc.dart';
import 'package:news_app/cards/featured_card.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:provider/provider.dart';

class Featured extends StatefulWidget {
  Featured({Key key}) : super(key: key);

  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  int listIndex = 0;

  @override
  Widget build(BuildContext context) {
    final fb = context.watch<FeaturedBloc>();
    double w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
        //   child: Row(
        //     children: <Widget>[
        //       Container(
        //         height: 22,
        //         width: 4,
        //         decoration: BoxDecoration(
        //             color: Theme.of(context).primaryColor,
        //             borderRadius: BorderRadius.circular(10)),
        //       ),
        //       SizedBox(
        //         width: 6,
        //       ),
        //       Text(
        //         'featured',
        //         style: TextStyle(
        //             fontSize: 18,
        //             fontWeight: FontWeight.bold),
        //       ).tr(),
        //     ],
        //   ),
        // ),
        Container(
          height: 250,
          //color: Colors.green,
          width: w,
          child: PageView.builder(
            controller: PageController(initialPage: 0),
            scrollDirection: Axis.horizontal,
            itemCount: fb.data.isEmpty ? 1 : fb.data.length,
            onPageChanged: (index) {
              setState(() {
                listIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              if (fb.data.isEmpty) return LoadingFeaturedCard();
              return FeaturedCard(d: fb.data[index], heroTag: 'featured$index');
            },
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Center(
          child: DotsIndicator(
            dotsCount: fb.data.isEmpty ? 5 : fb.data.length,
            position: listIndex.toDouble(),
            decorator: DotsDecorator(
              color: Colors.black26,
              activeColor: Colors.black,
              spacing: EdgeInsets.only(left: 6),
              size: const Size.square(5.0),
              activeSize: const Size(20.0, 4.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        )
      ],
    );
  }
}





