import 'package:flutter/material.dart';

InputDecoration inputDecoration(hint, label, controller) {
  return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(),
      labelText: label,
      contentPadding: EdgeInsets.only(right: 0, left: 10),
      suffixIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey[300],
          child: IconButton(
              icon: Icon(Icons.close, size: 15),
              onPressed: () {
                controller.clear();
              }),
        ),
      ));
}

ButtonStyle buttonStyle(Color color) {
  return ButtonStyle(
    padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15)),
      backgroundColor: MaterialStateProperty.resolveWith((states) => color),
      shape: MaterialStateProperty.resolveWith((states) =>
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))));
}
