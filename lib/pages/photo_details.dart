import 'package:chainstep_image_gallery/models/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPage extends StatefulWidget {
  final CameraImage image;
  final Image cachedImage;
  const PhotoPage({Key key, @required this.image, @required this.cachedImage})
      : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  ImageProvider displayPhoto;
  ImageProvider preCachedImage;

  @override
  void initState() {
    displayPhoto = widget.cachedImage.image;
    preCachedImage = Image.file(widget.image.imageFile()).image;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(preCachedImage, context).whenComplete(() {
      setState(() {
        displayPhoto = preCachedImage;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        imageProvider: displayPhoto,
        loadingBuilder: (context, progress) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: progress == null
                  ? null
                  : progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes,
            ),
          ),
        ),
        heroAttributes:
            PhotoViewHeroAttributes(tag: 'gallery_${widget.image.id}'),
      ),
    );
  }
}
