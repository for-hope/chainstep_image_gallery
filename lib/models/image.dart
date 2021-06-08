import 'dart:io';

import 'dart:ui';

class GalleryImage {
  final String id;
  //File imageFile;
  final int width;
  final int height;
  final String filePath;
  final String title;
  Size size;

  GalleryImage(this.id, this.title, this.filePath, this.width, this.height);

  File imageFile() {
    return File(this.filePath);
  }

  double tileSize() {
    return (this.height >= this.width) ? 2 : 1.5;
  }

  GalleryImage.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.width = json['width'],
        this.height = json['height'],
        this.title = json['title'],
        this.filePath = json['file'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'width': width,
        'height': height,
        'file': filePath,
      };
}
