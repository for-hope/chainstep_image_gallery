
import 'dart:io';

import 'package:chainstep_image_gallery/models/image.dart';
import 'package:chainstep_image_gallery/services/cache.dart';
import 'package:photo_manager/photo_manager.dart';
import '../utils/constants.dart';


Future<List<GalleryImage>> fetchImagesFromStorage(String folder) async {
  List<GalleryImage> filesList = [];
  var result = await PhotoManager.requestPermissionExtend();
  if (result.isAuth) {
    toastMessage(text: "Permissions OK");
    List<AssetPathEntity> mediaDirectoriesList = await PhotoManager.getAssetPathList(type: RequestType.image);
    print("Media directories $mediaDirectoriesList");
    for (var directory in mediaDirectoriesList) {
      AssetPathEntity mediaDirectory = directory;
      if (mediaDirectory.name == folder) {

        List<AssetEntity> imageList = await mediaDirectory.assetList;


        for (var image in imageList) {

            File imageFile = await image.file;
            String id = image.id;
            String title = image.title;
            int orientation = image.orientation;
            int width = (orientation == 0) ? image.width : image.height;
            int height = (orientation == 0) ? image.height : image.width;
            filesList.add(GalleryImage(id, title, imageFile.path, width, height));

        }
      }
    }

  } else {
    toastMessage(text: "Permissions FAILED");
  }
  cachePaths(cacheKey, filesList);
  return filesList;
}






