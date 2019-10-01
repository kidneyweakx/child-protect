import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'mainPage.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  // Open Camera
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Child-Protection',
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.blueGrey,
      ),
      home: HomePage(cameras),
    );
  }
}
