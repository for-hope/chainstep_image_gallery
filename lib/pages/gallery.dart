import 'dart:convert';

import 'package:chainstep_image_gallery/models/image.dart';
import 'package:chainstep_image_gallery/pages/photo_details.dart';
import 'package:chainstep_image_gallery/services/cache.dart';

import 'package:chainstep_image_gallery/utils/constants.dart';
import 'file:///C:/Users/songo/AndroidStudioProjects/chainstep_image_gallery/lib/services/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<GalleryImage> images = [];

  @override
  void initState() {
    //fetch images from cache or photo_manager
    retrieveImages();
    super.initState();
  }

  void retrieveImages() async {
    //retrieve and show cache if possible
    List jsonList = await retrieveCache(cacheKey);
    List<GalleryImage> cachedGImages = [];
    jsonList.forEach((element) {
      cachedGImages.add(GalleryImage.fromJson(element));
    });

    if (cachedGImages.isNotEmpty) {
      toastMessage(text: "Loaded from cache");
      print("From Cache");
      updateImages(cachedGImages);
    } else {
      toastMessage(text: "Loaded from storage");
      print("From Storage");
      //await fetchImagesFromStorage().then((images) => updateImages(images));
    }
    //fetch updated images from photo_manager
    refreshImages();
  }

  void updateImages(List<GalleryImage> imageList) {
    setState(() {
      images = imageList.sublist(0, 200);
    });
  }

  void refreshImages() async {
    await fetchImagesFromStorage().then((value) {
      if (!listEquals(images, value)) {
        setState(() {
          images = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (images.length > 0) ? staggeredGrid() : loadingView();
    //return staggeredGrid();
  }

  Widget loadingView() {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget staggeredGrid() {
    return SliverStaggeredGrid.countBuilder(
      crossAxisCount: 4,
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            (images[index].imageFile().existsSync())
                ? Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => PhotoPage(
                              image: images[index],
                              cachedImage: imageTile(index),
                            ),
                        transitionDuration: Duration(milliseconds: 400),
                        fullscreenDialog: true))
                : toastMessage(text: "Image not found.");
          },
          child: Hero(
            tag: "gallery_${images[index].id}",
            child: (images[index].imageFile().existsSync())
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: imageTile(index))
                : invalidImage(index),
          )),
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, (index.isEven) ? 3 : 2),
      mainAxisSpacing: 25.0,
      crossAxisSpacing: 20.0,
      //padding: EdgeInsets.only(left: 12, right: 12),

    );
  }

  Widget invalidImage(index) {
    refreshImages();
    return Icon(Icons.broken_image);
  }

  Image imageTile(int index) {
    var image = images[index].imageFile();
    var imageWidget = Image.file(
      image,
      fit: BoxFit.cover,
      cacheWidth: 220,
    );
    return imageWidget;
  }
}
