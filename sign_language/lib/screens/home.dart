// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import 'backgr.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();
@override
void initState() {
  super.initState();
  loadModel().then((value){
    setState(() {
      
    });
  });
  }

  detectImage(File image) async {
    var output = await Tflite.detectObjectOnImage(
      path: image.path,
      //numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/predmodel.tflite",
      labels: "",
    );
  }
  @override
  void dispose(){
    super.dispose();
  }

  pickImage()async{
    var image = await picker.pickImage(source: ImageSource.camera);
    if(image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }
  pickgalleryImage()async{
    var image = await picker.pickImage(source: ImageSource.gallery);
    if(image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: size.height * 0.25),
            //Center(child: Image.asset('assets/gif.gif')),
            SizedBox(height: size.height * 0.05),
            Text('Sign',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold)),
            Text('Language',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: size.height * 0.05),
            Center(child: _loading ? SizedBox(
              width: 350,
              child: Column(
                children: [
                  Image.asset("assets/gif.gif"),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ):Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: Image.file(_image),
                  ),
                  SizedBox(height: size.height * 0.05),
                  // ignore: unnecessary_null_comparison
                  _output != null ? Text('${_output[0]['label']}',style: TextStyle(color: Colors.white,fontSize: 15),):Container(),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            )),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        pickImage();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                        primary: Color(0xff166D68),
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.25,
                            vertical: size.height * 0.02),
                      ),
                      child: Text(
                        'Capture a photo',
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.1),
                    ElevatedButton(
                      onPressed: () {
                        pickgalleryImage();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                        primary: Color(0xff166D68),
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.25,
                            vertical: size.height * 0.02),
                      ),
                      child: Text(
                        'Select a photo',
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
