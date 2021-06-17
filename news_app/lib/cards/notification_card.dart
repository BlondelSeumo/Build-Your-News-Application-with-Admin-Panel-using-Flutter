import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/config/config.dart';
import 'package:news_app/models/notification.dart';
import 'package:news_app/pages/notification_details.dart';
import 'package:news_app/utils/next_screen.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel d;
  const NotificationCard({Key key, @required this.d})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(5.0),
              ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[500]),
                  shape: BoxShape.circle,
                  
                ),
                child: Image.asset(Config().splashIcon, fit: BoxFit.cover,),
              ),
              Expanded(
                              child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          d.title,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 15,),


                      Row(
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.time_solid,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            d.date,
                            style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13),
                          ),
                          
                          
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )
          
          ),
      onTap: () {
        
         nextScreen(context, NotificationDetails(data: d));   
      },
    );
  }
}
