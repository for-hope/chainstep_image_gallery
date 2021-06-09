

import 'package:chainstep_image_gallery/pages/gallery.dart';
import 'package:chainstep_image_gallery/utils/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery',
      home: ChainstepGallery(title: 'Chainstep Gallery'),
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        accentColor: accentColor,


      ),
    );
  }
}

class ChainstepGallery extends StatefulWidget {
  ChainstepGallery({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChainstepGalleryState createState() => _ChainstepGalleryState();
}

class _ChainstepGalleryState extends State<ChainstepGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          color: accentColor,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              sliverAppBar(),
              sliverContainer(),
              sliverGrid(),
            ],
          ),
        ),
      ),
    );
  }

  //commit
  //permissions

  Widget sliverAppBar() {
    return SliverAppBar(
      title: Text("Gallery"),
      centerTitle: true,
      pinned: true,
      leading: IconButton(
        icon: Icon(
          Icons.exit_to_app,
          color: Colors.white70,
        ),
        onPressed: exitAppDialog,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Colors.white70,
          ),
          onPressed: () => aboutDialog(),
        ),
      ],
      backgroundColor: primaryColor,
      expandedHeight: 220.0,
      stretch: true,
      stretchTriggerOffset: 100,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        //collapseMode: CollapseMode.pin,
        centerTitle: true,
        collapseMode: CollapseMode.parallax,
        //title: Text("Gallery"),
        background: Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Image Gallery',
                style: GoogleFonts.roboto(
                    color: Colors.deepPurple.shade100.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    fontSize: 37),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sliverContainer() {
    return SliverToBoxAdapter(
      child: Container(
        color: primaryColor,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 10),
                  child: Text(
                    "Recent Folder",
                    style: GoogleFonts.montserrat(
                        fontSize: 24, color: Colors.white70),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sliverGrid() {
    return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12), sliver: GalleryPage());
  }

  void exitAppDialog() {
    Widget okButton = MaterialButton(
        child: Text("Yes"), onPressed: () => SystemNavigator.pop());

    Widget noButton = MaterialButton(
        child: Text("No"), onPressed: () => Navigator.of(context).pop(false));
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Exit App"),
              content: Text("Would you like to exit the application?"),
              actions: [noButton, okButton],
            ));
  }

  void aboutDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("About"),
              content: Text(
                  "Hello! This simple application was developed by Lamine Fetni using Flutter <3."),
            ));
  }

  void requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      toastMessage(text: "Permission already granted.");
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]);
    }
  }
}

