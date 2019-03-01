import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:camera/camera.dart';
import './page/users.dart';
import './page/add_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePage();
  }
}

class MyHomePage extends State<MyApp> {
  int _selectedPage = 0;
  final _pageOptions = [
    UsersPage(),
    AddDataPage(),
  ];

  // File _image;

  // Future getImage() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _image = image;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Camera Demo'),
        ),
        body: _pageOptions[_selectedPage],
        // body: new Center(
        //   child: _image == null ? new Text('No image!') : new Image.file(_image),
        // ),
        // floatingActionButton: new FloatingActionButton(
        //   onPressed: getImage,
        //   tooltip: 'Take Picture',
        //   child: new Icon(FontAwesomeIcons.image),
        // ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.users),
              title: Text('Users'),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.plusSquare),
              title: Text('New Data'),
            ),
          ],
        ),
      ),
    );
  }
}
