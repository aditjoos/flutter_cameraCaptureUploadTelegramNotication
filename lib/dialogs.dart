import 'package:flutter/material.dart';

class Dialogs {
  info(BuildContext context, String title, String description){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          title: Text(title, style: new TextStyle(color: Colors.blue),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                new Text(description),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }
}