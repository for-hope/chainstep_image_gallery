import 'dart:io';

import 'dart:ui';

class CameraImage {
  final String id;
  final File imageFile;
  int width;
  int height;
  Size size;

  CameraImage(this.id, this.imageFile);
}