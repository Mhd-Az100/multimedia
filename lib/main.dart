import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: Getimage()));
}

enum AppState { free, picked, cropped }

class Getimage extends StatefulWidget {
  @override
  _GetimageState createState() => _GetimageState();
}

class _GetimageState extends State<Getimage> {
  File _image;
  final picker = ImagePicker();
  AppState state;
  Future getImage(x) async {
    final pickedFile = await picker.getImage(source: x);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Null> _cropImage() async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: _image.path,
    );
    if (croppedImage != null) _image = croppedImage;
    setState(() {
      state = AppState.cropped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Pick Image"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _cropImage();
            });
          },
          child: Icon(
            Icons.crop,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => getImage(ImageSource.gallery),
                  icon: Icon(Icons.image),
                  label: Text("Get_Images"),
                ),
                TextButton.icon(
                  onPressed: () => getImage(ImageSource.camera),
                  icon: Icon(Icons.camera_alt),
                  label: Text("Open_Camera"),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue[50], width: 100)),
                padding: EdgeInsets.all(5.0),
                child: _image == null
                    ? Image.asset("images/mario.jpg")
                    : Image.file(_image),
              ),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
