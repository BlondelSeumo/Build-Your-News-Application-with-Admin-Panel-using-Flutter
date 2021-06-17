


import 'package:flutter/material.dart';

void openDialog (context, title, message){
  showDialog(
    context: context,
    
    builder: (BuildContext context){
      return AlertDialog(
        content: Text(message),
        title: Text(title),
        actions: <Widget>[
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('OK'))
        ],

      );
    }
    
    );
}