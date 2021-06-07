import 'dart:io';

import 'package:chainstep_image_gallery/models/image.dart';
import 'package:photo_manager/photo_manager.dart';

import 'constants.dart';

Future<List<CameraImage>> getCameraImages() async {
  List<CameraImage> filesList = [];
  var result = await PhotoManager.requestPermissionExtend();
  if (result.isAuth) {
    toastMessage(text: "Permissions OK");
    List<AssetPathEntity> mediaDirectoriesList = await PhotoManager.getAssetPathList(type: RequestType.image);
    for (var directory in mediaDirectoriesList) {
      AssetPathEntity mediaDirectory = directory;
      if (mediaDirectory.name == 'Camera') {
        List<AssetEntity> imageList = await mediaDirectory.assetList;


        for (var image in imageList) {
          File imageFile = await image.file;
          String id = image.id;
          filesList.add(CameraImage(id, imageFile));
        }
      }
    }

  } else {
    toastMessage(text: "Permissions FAILED");
    /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
  }

  return filesList;
}

