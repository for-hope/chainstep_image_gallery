import 'dart:io';

import 'package:chainstep_image_gallery/models/image.dart';
import 'package:chainstep_image_gallery/utils/constants.dart';
import 'package:chainstep_image_gallery/utils/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

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
    var mList = await getCameraImages();
    setState(() {
      imagesList = mList;
    });
    print(imagesList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: (imagesList.length > 0) ? GridView.builder(
          //cacheExtent: 9999,
          itemCount: imagesList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemBuilder: (context, idx) {
            return Image.file(imagesList[idx].imageFile,
              fit: BoxFit.cover,
              scale: 0.1,
              cacheWidth: 150,
            );
          }) : Text("Empty List",),
    );
  }
}
