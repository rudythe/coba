import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'net_file_image.dart';
import 'vw_image_viewer.dart';

class BasicWidget {
  List<Shadow> outlinedText(int width, Color color, int fontSize) {
    // Set<Shadow> result = HashSet();
    List<Shadow> res = List<Shadow>();
    for (int x = 1; x < width + fontSize; x++) {
      for (int y = 1; y < width + fontSize; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        res.add(Shadow(
            offset: Offset(-width / offsetX, -width / offsetY), color: color));
        res.add(Shadow(
            offset: Offset(-width / offsetX, width / offsetY), color: color));
        res.add(Shadow(
            offset: Offset(width / offsetX, -width / offsetY), color: color));
        res.add(Shadow(
            offset: Offset(width / offsetX, width / offsetY), color: color));
      }
    }
    return res;
  }
}

class RoundedContainer extends StatelessWidget {
  final double radius;
  final double borderWidth;
  final double width;
  final double height;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final Color borderColor;

  RoundedContainer({@required this.child,
    this.padding = const EdgeInsets.all(6.0),
    this.margin,
    this.color,
    this.borderColor = Colors.black54,
    this.radius = 6,
    this.borderWidth = 0.5,
    this.width,
    this.height});

  @override
  Widget build(BuildContext context) {
    _decoration () {

    }
    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.all(Radius.circular(radius))
      ),
      child: child,
    );
  }
}

class ItemImage extends StatelessWidget {
  final double imageHeight;
  final double titleHeight;
  final String imagePath;
  final String title;
  ItemImage(
      {@required this.imagePath,
      this.imageHeight = 80,
      this.titleHeight = 14,
      this.title = ""});

  _getTitle(BuildContext context) {
    return Container(
      width: imageHeight,
      height: titleHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.7,
            child: Container(
              color: Theme.of(context).indicatorColor,
            ),
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  shadows: BasicWidget().outlinedText(1, Colors.white, 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
//    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: imageHeight,
        child: Hero(
          tag: title,
          // transitionOnUserGestures: true,
          child: Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewImageViewer(
                      photos: imagePath,
                      title: title,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: imageHeight,
                    height: imageHeight,
                    child: NetworkFileImage(
                      imagePath: imagePath,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  (title.isNotEmpty) ? _getTitle(context) : Container(),
                ],
              ),
            ),
          ),
        )
        // GestureDetector(
        //   onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) =>
        //     ViewImageViewer(
        //       photos: imagePath,
        //     ),
        // ));
        //   },
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(8.0),
        //     child: Stack(
        //       children: [
        //         Container(
        //           width: imageHeight,
        //           height: imageHeight,
        //           child: NetworkFileImage(
        //             imagePath: imagePath,
        //             fit: BoxFit.fitWidth,
        //           ),
        //         ),
        //         (title.isNotEmpty) ? _getTitle(context) : Container(),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
