import 'package:flutter/material.dart';

class NetworkFileImage extends FadeInImage {
  final String imagePath;
  NetworkFileImage({Key key, 
    @required this.imagePath, 
    // @required ImageProvider placeholder,
    // @required ImageProvider image,
    bool excludeFromSemantics: false,
    String imageSemanticLabel,
    Duration fadeOutDuration: const Duration(milliseconds: 10),
    Curve fadeOutCurve: Curves.easeOut,
    Duration fadeInDuration: const Duration(milliseconds: 10),
    Curve fadeInCurve: Curves.easeIn,
    double width,
    double height,
    BoxFit fit,
    AlignmentGeometry alignment: Alignment.center,
    ImageRepeat repeat: ImageRepeat.noRepeat,
    bool matchTextDirection: false}): 
  super(key: key, 
    placeholder: AssetImage('assets/images/inllogo.jpg'), 
    image: NetworkImage('https://shbjaya.s3.ap-northeast-2.amazonaws.com/Nice+Sunset.jpg'),
    excludeFromSemantics: excludeFromSemantics,
    imageSemanticLabel: imageSemanticLabel,
    fadeOutDuration: fadeOutDuration,
    fadeOutCurve: fadeOutCurve,
    fadeInDuration: fadeInDuration,
    fadeInCurve: fadeInCurve,
    width: width,
    height: height,    
    fit: fit,
    alignment: alignment,
    repeat: repeat,
    matchTextDirection: matchTextDirection,) {
      // image =
    }
}

// class NetworkFileImage extends StatelessWidget {
//   final String imagePath;
//   final AlignmentGeometry alignment;
//   final double width;
//   final double height;
//   final BoxFit fit;
//   final FilterQuality filterQuality;
//   final Color color;
//   final Rect centreSlice;

//   Image _fileImage() {    
//     return Image(
//       alignment: this.alignment,
//       image: NetworkImage(imagePath),
//       width: this.width,
//       fit: this.fit,
//     );
//   }
  
//   NetworkFileImage({Key key, 
//     @required this.imagePath, 
//     this.alignment,
//     this.width,
//     this.height, 
//     this.fit,
//   }) : super(key: key);

//   Widget build(BuildContext context) {
//     return Container (
//       child: _fileImage(),
//     );
//   }
// }