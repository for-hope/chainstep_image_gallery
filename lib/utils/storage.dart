
import 'dart:io';

import 'package:chainstep_image_gallery/models/image.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'dart:convert';

Future<List<CameraImage>> getCameraImages() async {
  List<CameraImage> filesList = [];
  var result = await PhotoManager.requestPermissionExtend();
  if (result.isAuth) {
    toastMessage(text: "Permissions OK");
    List<AssetPathEntity> mediaDirectoriesList = await PhotoManager.getAssetPathList(type: RequestType.image);
    //print("Media directories $mediaDirectoriesList");
    for (var directory in mediaDirectoriesList) {
      AssetPathEntity mediaDirectory = directory;
      if (mediaDirectory.name == 'Camera') { //todo change back to recent

        List<AssetEntity> imageList = await mediaDirectory.assetList;


        for (var image in imageList) {

            File imageFile = await image.file;
            String id = image.id;
            int orientation = image.orientation;
            int width = (orientation == 0) ? image.width : image.height;
            int height = (orientation == 0) ? image.height : image.width;
            filesList.add(CameraImage(id, imageFile.path, width, height));

        }
      }
    }

  } else {
    toastMessage(text: "Permissions FAILED");
  }
  cacheImageList('image_cache', filesList);
  return filesList;
}

Future<void> cacheImageList(String key,List<CameraImage> imageList) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> valuesList = [];
  imageList.forEach((element) {
    String json = jsonEncode(element.toJson());
    valuesList.add(json);
  });
  //String value = json.encode(imageList[0].toJson());
  await prefs.setStringList(key, valuesList);
  
}
