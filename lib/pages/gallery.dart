import 'dart:convert';

import 'package:chainstep_image_gallery/models/image.dart';
import 'package:chainstep_image_gallery/pages/photo_details.dart';
import 'package:chainstep_image_gallery/utils/constants.dart';
import 'package:chainstep_image_gallery/utils/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<CameraImage> imagesList = [];
  @override
  void initState() {
    retrieveImagesList();
    super.initState();
  }

  void retrieveImagesList() async {
    List jsonList = await read('image_cache');
    List<CameraImage> imageList = [];
    print("Lenght of json = " + jsonList.length.toString());
    jsonList.forEach((element) {
      imageList.add(CameraImage.fromJson(element));
    });
    print("Lenght of imagelist = " + imageList.length.toString());
    var mList = [];

    if (imageList.isEmpty) {
      toastMessage(text: "Loaded from storage");
      print("From Storage");
      mList = await getCameraImages();
    } else {
      toastMessage(text: "Loaded from cache");
      print("From Cache");
      mList = imageList;
    }
    setState(() {
      imagesList = mList;
    });
    print(imagesList.length);
    print(DateTime.now().microsecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: (imagesList.length > 0)
          ? staggeredGridView()
          : Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  Widget staggeredGridView() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: imagesList.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => PhotoPage(
                      image: imagesList[index],
                      cachedImage: imageTile(index),
                    ),
                transitionDuration: Duration(milliseconds: 400),
                fullscreenDialog: true)),
        child: Hero(
            tag: "gallery_${imagesList[index].id}", child: imageTile(index)),
      ),
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, imagesList[index].tileSize()),
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 5.0,
    );
  }

  Image imageTile(int index) {
    return Image.file(
      imagesList[index].imageFile(),
      fit: BoxFit.cover,
      cacheWidth: 220,
    );
  }

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var stringsList = prefs.getStringList(key);
    if (stringsList != null){
      var jsonList = [];
      stringsList.forEach((element) {
        jsonList.add(jsonDecode(element));
      });
      return jsonList;
    } else {
      return [];
    }

    //return json.decode(prefs.getString(key));
  }
}
