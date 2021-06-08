import 'package:chainstep_image_gallery/models/image.dart';
import 'package:chainstep_image_gallery/pages/photo_details.dart';
import 'package:chainstep_image_gallery/utils/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
      child: (imagesList.length > 0)
          ? staggeredGridView()
          : Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
          ),
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
          tag: "gallery_${imagesList[index].id}",
          child: imageTile(index)
        ),
      ),
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, imagesList[index].tileSize()),
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 5.0,
    );
  }

  Image imageTile(int index) {
    return  Image.file(
      imagesList[index].imageFile,
      fit: BoxFit.cover,
      cacheWidth: 220,
    );
  }

}
