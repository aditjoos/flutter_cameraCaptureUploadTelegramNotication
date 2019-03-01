import 'dart:async';
import 'package:async/async.dart';
import 'dart:io';

import 'package:teledart/telegram.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import './../dialogs.dart';

class AddDataPage extends StatefulWidget {
  AddDataPageState createState() => AddDataPageState();
}

class AddDataPageState extends State<AddDataPage> {
  TextEditingController controllerNama = new TextEditingController();
  TextEditingController controllerDept = new TextEditingController();

  File _image;

  Dialogs dialogs = new Dialogs();

  Future getImageGallery(BuildContext context) async {
    var imgFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    String title = controllerNama.text;

    img.Image image = img.decodeImage(imgFile.readAsBytesSync());
    img.Image smallerImgFile = img.copyResize(image, 500);

    var compressImg = new File("$path/ktp_$title.jpg")..writeAsBytesSync(img.encodeJpg(smallerImgFile));

    setState(() {
      _image = compressImg;
    });

    Navigator.pop(context);
  }

  Future getImageCamera(BuildContext context) async {
    var imgFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    String title = controllerNama.text;

    img.Image image = img.decodeImage(imgFile.readAsBytesSync());
    img.Image smallerImgFile = img.copyResize(image, 500);

    var compressImg = new File("$path/ktp_$title.jpg")..writeAsBytesSync(img.encodeJpg(smallerImgFile));

    setState(() {
      _image = compressImg;
    });

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {

    Future addData(File imageFile) async{
      var uri = Uri.parse("http://192.168.43.58/coba_flutter/addData.php");
      var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var request = new http.MultipartRequest("POST", uri);

      var multipartfile = new http.MultipartFile("itemKtp", stream, length, filename: basename(imageFile.path));
      request.fields['itemNama'] = controllerNama.text;
      request.fields['itemDept'] = controllerDept.text;
      request.files.add(multipartfile);

      var response = await request.send();

      if (response.statusCode == 200) {
        dialogs.info(context, "Success", "Data berhasil disimpan.");

        //telegram
        
        // http.get("https://api.telegram.org/bot"+botToken+"/sendMessage?chat_id=555441244&text="+text+"&parse_mode=markdown");

        // http.post("https://api.telegram.org/bot"+botToken+"/sendPhoto", body: {
        //   "chat_id": "555441244",
        //   "photo": imageFile
        // });

        int chatId = 555441244;
        String botToken = "762529332:AAHTe9DnG1bbpc_Q6_xhEnwZIyN5B-02Inw";
        String caption = "Pegawai baru bernama : *"+controllerNama.text+"* telah terdaftar di database.";

        Telegram telegram = new Telegram(botToken);

        telegram.sendPhoto(chatId, imageFile, caption: caption, parse_mode: "markdown");

      } else {
        // print("gagal");
        dialogs.info(context, "Failed", "Data gagal disimpan.");
      }
    }

    return Container(
      padding: EdgeInsets.all(25.0),
      child: ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new TextField(
                controller: controllerNama,
                decoration:
                    new InputDecoration(hintText: "Nama", labelText: "Nama"),
              ),
              new TextField(
                controller: controllerDept,
                decoration: new InputDecoration(
                    hintText: "Departemen", labelText: "Departemen"),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _image == null
                    ? new Text(
                        "Belum ada foto yang dipilih!",
                        style: new TextStyle(color: Colors.red),
                      )
                    : new Text("Foto sudah dipilih."),
                    new FlatButton(
                      padding: EdgeInsets.all(5.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      child: Icon(FontAwesomeIcons.solidFileImage, color: Colors.white,),
                      color: Colors.blue,
                      onPressed: (){
                        return showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context){
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              title: new Text("Pilih source gambar", style: new TextStyle(color: Colors.blue),),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    new FlatButton(
                                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.only(right: 10.0),
                                            child: new Text("Galeri", style: new TextStyle(color: Colors.white),),
                                          ),
                                          new Icon(FontAwesomeIcons.images, color: Colors.white,),
                                        ],
                                      ),
                                      color: Colors.blue,
                                      onPressed: () {
                                        getImageGallery(context);
                                      },
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.all(5.0),
                                    ),
                                    new FlatButton(
                                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.only(right: 10.0),
                                            child: new Text("Kamera", style: new TextStyle(color: Colors.white),),
                                          ),
                                          new Icon(FontAwesomeIcons.cameraRetro, color: Colors.white,),
                                        ],
                                      ),
                                      color: Colors.blue,
                                      onPressed: () {
                                        getImageCamera(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              new FlatButton(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "Simpan ",
                      style: new TextStyle(color: Colors.white),
                    ),
                    new Icon(
                      FontAwesomeIcons.solidPaperPlane,
                      color: Colors.white,
                    )
                  ],
                ),
                color: Colors.blue,
                onPressed: () {
                  addData(_image);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
