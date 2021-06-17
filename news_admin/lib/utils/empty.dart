import 'package:flutter/material.dart';



Widget emptyPage (icon, messgae){
  return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Icon(icon, size: 80, color: Colors.grey,),
        SizedBox(height: 10,),
        Text(messgae, style: TextStyle(fontSize: 20, color:Colors.grey, fontWeight: FontWeight.w600), textAlign: TextAlign.center,)
      ],),
    );
}