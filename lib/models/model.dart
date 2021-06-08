class MimeType {

  String imageJPEG = 'image/jpeg';


  String imagePNG = 'image/png';


  String imageJPG = 'image/jpg';


  bool isSupported(String mimType) {
    return  (mimType == imageJPEG || mimType == imagePNG || mimType == imageJPG);
  }
}