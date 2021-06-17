


import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'styles.dart';

showNotificationPreview(context, title, description) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(80),
          elevation: 0,
          children: <Widget>[

            Text('Preview', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.deepPurpleAccent),),
            
            SizedBox(height: 20,),
            Text(title,
                
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            SizedBox(
              height: 5,
            ),
            Html(
                    data: '''$description''',
                    defaultTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    onLinkTap: (url){
                      launch(url);
                    },
                  ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                        style: buttonStyle(Colors.deepPurpleAccent),
                        child: Text(
                          'Close',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                ],
              ),
            ),
            
            
          ],
        );
      });
}