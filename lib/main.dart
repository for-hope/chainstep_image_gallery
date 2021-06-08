import 'dart:convert';

import 'package:chainstep_image_gallery/models/image.dart';
import 'package:chainstep_image_gallery/pages/gallery.dart';
import 'package:chainstep_image_gallery/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ChainstepGallery(title: 'Gallery Page'),
    );
  }
}

class ChainstepGallery extends StatefulWidget {
  ChainstepGallery({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ChainstepGalleryState createState() => _ChainstepGalleryState();
}

class _ChainstepGalleryState extends State<ChainstepGallery> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: GalleryPage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
                requestPermission();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var stringsList = prefs.getStringList(key);
    var jsonList = [];
    stringsList.forEach((element) {
      jsonList.add(jsonDecode(element));
    });
    return jsonList;
    //return json.decode(prefs.getString(key));
  }

  void requestPermission() async {

    //var filesList = await read('image_cache') as List<CameraImage>;
    List jsonList = await read('image_cache');
    List<CameraImage> imageList = [];
    jsonList.forEach((element) { imageList.add(CameraImage.fromJson(element)); });
    print(imageList.length);
    //filesList.forEach((element) {print(element.id);});

    if (await Permission.storage.request().isGranted) {
      toastMessage(text: "Permission already granted.");
      //todo go on
    // Either the permission was already granted before or the user just granted it.
    } else {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]);
    }
  }
}
