import 'dart:convert';

import 'package:chainstep_image_gallery/models/image.dart';
import 'package:shared_preferences/shared_preferences.dart';

remove(String key) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  } catch (Exception) {
    print("Err : " + Exception.toString());
  }
}

cachePaths(String key, List<GalleryImage> imageList) async {
  remove(key);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> valuesList = [];
  imageList.forEach((element) {
    String json = jsonEncode(element.toJson());
    valuesList.add(json);
  });
  //String value = json.encode(imageList[0].toJson());
  await prefs.setStringList(key, valuesList);
}

retrieveCache(String key) async {
  final prefs = await SharedPreferences.getInstance();
  var stringsList = prefs.getStringList(key);
  var jsonList = [];
  if (stringsList != null) {
    stringsList.forEach((element) {
      jsonList.add(jsonDecode(element));
    });
  }
  return jsonList;
}
