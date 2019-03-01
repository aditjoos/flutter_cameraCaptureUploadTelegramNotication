import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatelessWidget {
  Future<List> getData() async {
    final response = await http.get("http://192.168.43.58/coba_flutter/getData.php");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? new ItemList(list: snapshot.data,)
              : new Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {

  List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i){
        return new Container(
          margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: new LinearGradient(
              colors: [Colors.blue, Colors.cyan]
            ),
          ),
          child: new ListTile(
            title: new Text(list[i]['nama'], style: new TextStyle(color: Colors.white),),
            leading: new Icon(FontAwesomeIcons.user, color: Colors.white,),
            subtitle: new Text(list[i]['dept'], style: new TextStyle(color: Colors.white),),
          ),
        );
      },
    );
  }
}
