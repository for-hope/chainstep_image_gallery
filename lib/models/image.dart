import 'dart:io';

import 'dart:ui';

class CameraImage {
  final String id;
  //File imageFile;
  final int width;
  final int height;
  final String filePath;
  Size size;

  CameraImage(this.id, this.filePath, this.width, this.height);

  File imageFile() {
    return File(this.filePath);
  }
  double tileSize() {
    return (this.height >= this.width) ? 2 : 1.5;
  }

  CameraImage.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.width = json['width'],
        this.height = json['height'],
        this.filePath = json['file'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'width': width,
        'height': height,
        'file': filePath,
      };
}
