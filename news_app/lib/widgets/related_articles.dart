import 'package:flutter/material.dart';
import 'package:news_app/blocs/related_articles_bloc.dart';
import 'package:news_app/cards/card3.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';



class RelatedArticles extends StatefulWidget {
  final String category;
  final String timestamp;
  final bool replace;
  RelatedArticles({Key key, @required this.category, @required this.timestamp, this.replace}) : super(key: key);

  @override
  _RelatedArticlesState createState() => _RelatedArticlesState();
}

class _RelatedArticlesState extends State<RelatedArticles> {


  @override
  void initState() {
    super.initState();
    context.read<RelatedBloc>().getData(widget.category, widget.timestamp);
  }


  @override
  Widget build(BuildContext context) {
    final rb = context.watch<RelatedBloc>();
    
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 0, top: 10,),
          child: Text('you might also like', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),).tr(),
        ),
        Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    height: 3,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(40)),
                  ),
        

        Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 15, bottom: 15),
              shrinkWrap: true,
              itemCount: rb.data.isEmpty ? 1 : rb.data.length,
              separatorBuilder: (context, index) => SizedBox(height: 15,),
              itemBuilder: (BuildContext context, int index) {
                if(rb.data.isEmpty) return Container();
                return Card3(d: rb.data[index], heroTag: null, replace: true,);
             },
            ),
          
        )
        
        
      ],
    );
  }
}





