import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:news_app/pages/welcome.dart';
import 'next_screen.dart';

openSignInDialog(context){
   return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx){
        return AlertDialog(
          title: Text('no sign in title').tr(),
          content: Text('no sign in subtitle').tr(),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
                nextScreenPopup(context, WelcomePage(tag: 'Popup'));
              }, 
              child: Text('sign in').tr(),),

              TextButton(
              onPressed: (){
                
                
                Navigator.pop(context);
              }, 
              child: Text('cancel').tr())
          ],
        );
      }
    );
 }