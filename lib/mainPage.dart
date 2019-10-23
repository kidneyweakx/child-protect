import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:math' as math;

import 'helper/camera.dart';
import 'helper/result.dart';
import 'helper/models.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res;
    switch (_model) {
      default:
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    }
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

_launchURL() async {
  const url = 'https://child-age.herokuapp.com/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchAPP() async {
  const pkg = 'com.Brokenleg.MR';
  if(await DeviceApps.isAppInstalled(pkg)){
    DeviceApps.openApp(pkg);
  } else {
    _launchURL();
  }
}
// UI
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: _model == ""
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('認證附近有大人'),
                    onPressed: () => onSelect(ssd),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
                Positioned(
                  left: screen.width / 4,
                  top: screen.height * 3 /4,
                  width:  screen.width / 2,
                  height: 40,
                  child: 
                    ce ? RaisedButton(
                      child: const Text('成功認證'),
                      onPressed: () => _launchAPP(),
                      color: Colors.red,
                    ):
                    RaisedButton(
                      child: const Text('認證失敗'),
                      onPressed: () => _launchURL(),
                    )
                  ),
              ],
            ),
    );
  }
}
