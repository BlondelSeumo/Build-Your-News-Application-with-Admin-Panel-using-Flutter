import 'package:line_icons/line_icons.dart';
import 'package:news_admin/utils/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news_admin/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/styles.dart';




Future showArticlePreview(context, String title, String description, String thumbnailUrl, int loves, String source, String date, String category, String contentType, String youtubeUrl) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            
            width: MediaQuery.of(context).size.width * 0.50,
            child: ListView(
              
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  child: CustomCacheImage(imageUrl: thumbnailUrl, radius: 0.0)
                ),

                contentType == 'image' ? Container()
                : InkWell(
                    child: Align(
                    alignment: Alignment.center,
                    child: Icon(LineIcons.play_circle, size: 100, color: Colors.white,),
                  ),
                  onTap: ()async{
                    if(await canLaunch(youtubeUrl)){
                       launch(youtubeUrl);
                    }else{
                      openToast1(context, "Youtube url is empty or have a probelem!");
                    }
                  },
                ),

                Positioned(
                  top: 10,
                  right: 20,
                  child: CircleAvatar(
                    child: IconButton(icon: Icon(Icons.close), onPressed:() => Navigator.pop(context) ),
                  ),
                )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                

                
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(category, style: TextStyle(
                          color: Colors.white
                        ),),
                        ),

                        SizedBox(width: 10,),

                        TextButton.icon(
                          style: buttonStyle(Colors.grey[200]),
                          onPressed: ()async{
                            if(await canLaunch(source)){
                              launch(source);
                            }else{
                              openToast1(context, "Source url is empty or have a probelem!");
                            }
                          }, 
                          icon: Icon(Icons.link, color: Colors.grey[900],), 
                          label: Text('Source Url', style: TextStyle(color: Colors.grey[900]),)
                        )
                      ],
                    ),

                    SizedBox(height: 20,),

                    Text(
                    title,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 10),
                    height: 3,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.circular(15)),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.favorite, size: 16, color: Colors.grey),
                      Text(loves.toString(), style: TextStyle(color: Colors.grey, fontSize: 13),),
                      SizedBox(width: 15,),
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      Text(date, style: TextStyle(color: Colors.grey, fontSize: 13),),
                      

                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Html(
                      defaultTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600]),
                      data: '''$description''',
                      onLinkTap: (url)async{
                        if(await canLaunch(url)){
                          launch(url);
                        }else{
                          openToast1(context, "Url is empty or have a probelem!");
                        }

                      },
                      onImageTap: (url)async{
                        if(await canLaunch(url)){
                          launch(url);
                        }else{
                          openToast1(context, "Image url is empty or have a probelem!");
                        }

                      },
                      
                      
                  ),


                  ],
                  ),
                ),
                SizedBox(height: 20,),
                
              ],
            ),
          ),
        );
      });
}
