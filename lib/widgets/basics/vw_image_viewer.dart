import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'package:sahabatjaya/main.dart';

class ViewImageViewer extends StatelessWidget {
  final String photos;
  final String title;
  ViewImageViewer({Key key, @required this.photos, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(

      onTapUp: (context, details, controllerValue) {
        // Navigator.pop(context, MaterialPageRoute(builder: (context) => MyHomePage()));
        Navigator.pop(context);
      },
      heroAttributes: PhotoViewHeroAttributes(
        tag: title,
        transitionOnUserGestures: true,
      ),
      imageProvider: NetworkImage(photos),
      // imageProvider: AssetImage('assets/images/inllogo.jpg'),
      backgroundDecoration: BoxDecoration(color: Colors.white),
    );
  }
}
