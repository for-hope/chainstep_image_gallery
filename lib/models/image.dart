import 'dart:io';

import 'dart:ui';

class CameraImage {
  final String id;
  final File imageFile;
  final int width;
  final int height;
  Size size;

  CameraImage(this.id, this.imageFile, this.width, this.height);

  double tileSize() {
    return (this.height >= this.width)? 2 : 1.5;
  }
}