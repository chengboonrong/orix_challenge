// // import 'package:camera/camera.dart';
// import 'dart:io';
// import 'dart:ui';
// // import 'dart:math';

// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:flutter/material.dart';
// // import 'package:extended_image/extended_image.dart';
// import 'package:image_picker/image_picker.dart';
// // import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';

// class FacePage extends StatefulWidget {
//   FacePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _FacePageState createState() => _FacePageState();
// }

// class _FacePageState extends State<FacePage>
//     with SingleTickerProviderStateMixin {
//   var _imageFile;
//   List<Face> _faces;
//   List<TextBlock> _rects = new List<TextBlock>();
//   Rect _rect;

//   Future _getImageAndDetectFace(camera) async {
//     final picker = ImagePicker();
//     // final imageFile = await picker.getImage(source: ImageSource.camera);
//     final imageFile = camera
//         ? await picker.getImage(source: ImageSource.camera)
//         : await picker.getImage(source: ImageSource.gallery);
//     final image = FirebaseVisionImage.fromFilePath(imageFile.path);
//     final faceDetector = FirebaseVision.instance
//         .faceDetector(FaceDetectorOptions(mode: FaceDetectorMode.accurate));
//     final faces = await faceDetector.processImage(image);
//     _rect = faces.last.boundingBox;

//     _imageFile = await imageFile.readAsBytes();
//     _imageFile = await decodeImageFromList(_imageFile);

//     if (mounted) {
//       setState(() {
//         _imageFile = _imageFile;
//         _faces = faces;
//         faces.length == 0
//             ? print('No face found, please try again.')
//             : print('Face found');
//       });
//     }
//   }

//   Future _getDocumentAndDetectText(camera) async {
//     final picker = ImagePicker();
//     // final imageFile = await picker.getImage(source: ImageSource.camera);
//     final imageFile = camera
//         ? await picker.getImage(source: ImageSource.camera)
//         : await picker.getImage(source: ImageSource.gallery);
//     final FirebaseVisionImage image =
//         FirebaseVisionImage.fromFilePath(imageFile.path);
//     final TextRecognizer cloudTextRecognizer =
//         FirebaseVision.instance.textRecognizer();
//     final VisionText visionText = await cloudTextRecognizer.processImage(image);
//     // _rects = visionText.blocks;
//     print(visionText.blocks);
//     print(visionText.text);

//     // _imageFile = await imageFile.readAsBytes();
//     // _imageFile = await decodeImageFromList(_imageFile);

//     // if (mounted) {
//     //   setState(() {
//     //     _imageFile = _imageFile;
//     //     // _faces = faces;
//     //     // faces.length == 0
//     //     // ? print('No face found, please try again.')
//     //     // : print('Face found');
//     //   });
//     // }
//   }

//   // Animation Floating buttons

//   bool isOpened = false;
//   AnimationController _animationController;
//   Animation<Color> _buttonColor;
//   Animation<double> _animateIcon;
//   Animation<double> _translateButton;
//   Curve _curve = Curves.easeOut;
//   double _fabHeight = 56.0;

//   @override
//   initState() {
//     _animationController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 500))
//           ..addListener(() {
//             setState(() {});
//           });
//     _animateIcon =
//         Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
//     _buttonColor = ColorTween(
//       begin: Colors.blue,
//       end: Colors.red,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Interval(
//         0.00,
//         1.00,
//         curve: Curves.linear,
//       ),
//     ));
//     _translateButton = Tween<double>(
//       begin: _fabHeight,
//       end: -14.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Interval(
//         0.0,
//         0.75,
//         curve: _curve,
//       ),
//     ));
//     super.initState();
//   }

//   @override
//   dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   animate() {
//     if (!isOpened) {
//       _animationController.forward();
//     } else {
//       _animationController.reverse();
//     }
//     isOpened = !isOpened;
//   }

//   Widget gallery() {
//     return Container(
//       child: FloatingActionButton(
//         onPressed: () {
//           // _getImageAndDetectFace(false);
//           _getDocumentAndDetectText(false);
//         },
//         tooltip: 'Choose a picture',
//         child: Icon(Icons.camera),
//       ),
//     );
//   }

//   Widget camera() {
//     return Container(
//       child: FloatingActionButton(
//         onPressed: () {
//           // _getImageAndDetectFace(true);
//           _getDocumentAndDetectText(true);
//         },
//         tooltip: 'Take a picture',
//         child: Icon(Icons.add_a_photo),
//       ),
//     );
//   }

//   Widget toggle() {
//     return Container(
//       child: FloatingActionButton(
//         backgroundColor: _buttonColor.value,
//         onPressed: animate,
//         tooltip: 'Toggle',
//         child: AnimatedIcon(
//           icon: AnimatedIcons.menu_close,
//           progress: _animateIcon,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Face Detector"),
//       ),
//       body: Container(),
//       // _imageFile == null ? Container() :
//       // : _imagesAndFaces(_imageFile, _rect),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           // Transform(
//           //   transform: Matrix4.translationValues(
//           //     0.0,
//           //     _translateButton.value * 3.0,
//           //     0.0,
//           //   ),
//           //   child: add(),
//           // ),
//           Transform(
//             transform: Matrix4.translationValues(
//               0.0,
//               _translateButton.value * 2.0,
//               0.0,
//             ),
//             child: gallery(),
//           ),
//           Transform(
//             transform: Matrix4.translationValues(
//               0.0,
//               _translateButton.value,
//               0.0,
//             ),
//             child: camera(),
//           ),
//           toggle(),
//         ],
//       ),

//       // FloatingActionButton(
//       //   onPressed: () {
//       //     _getImageAndDetectFace();
//       //   },
//       //   tooltip: 'Pick an image',
//       //   child: Icon(Icons.add_a_photo),
//     );
//   }
// }

// Widget _imagesAndFaces(imageFile, rect) {
//   return Center(
//     child: Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(blurRadius: 20),
//         ],
//       ),
//       margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
//       child: FittedBox(
//         child: SizedBox(
//           width: imageFile.width.toDouble(),
//           height: imageFile.height.toDouble(),
//           child: CustomPaint(
//             painter: FacePainter(rect: rect, imageFile: imageFile),
//           ),
//         ),
//       ),
//     ),
//   );
// }

// // Widget _imagesAndFaces(imageFile, faces, rect) {
// //   return Column(
// //     children: <Widget>[
// //       Flexible(
// //         flex: 10,
// //         child: Image.file(
// //           imageFile,
// //           fit: BoxFit.cover,
// //         ),
// //       ),
// //       Flexible(
// //         flex: 1,
// //         child: ListView(
// //           children: faces.map<Widget>((f) => _faceCoordinates(f)).toList(),
// //         ),
// //       ),
// //     ],
// //   );
// // }

// Widget _faceCoordinates(face) {
//   final pos = face.boundingBox;
//   return Container(
//     child: ListTile(
//       title: Text('(${pos.top}, ${pos.left}, ${pos.bottom}, ${pos.right})'),
//     ),
//   );
// }

// class FacePainter extends CustomPainter {
//   Rect rect;
//   var imageFile;

//   FacePainter({@required this.rect, @required this.imageFile});

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (imageFile != null) {
//       canvas.drawImage(imageFile, Offset.zero, Paint());
//     }

//     // for (Rect rectangle in rect) {
//     canvas.drawRect(
//       rect,
//       Paint()
//         ..color = Colors.teal
//         ..strokeWidth = 6.0
//         ..style = PaintingStyle.stroke,
//     );
//     // }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }

// // class FaceDetectorPainter extends CustomPainter {
// //   FaceDetectorPainter(this.imageSize, this.faces, {this.reflection = false});

// //   final bool reflection;
// //   final Size imageSize;
// //   final List<Face> faces;

// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final Paint paint = Paint()
// //       ..style = PaintingStyle.stroke
// //       ..strokeWidth = 2.0
// //       ..color = Colors.red;

// //     for (Face face in faces) {
// //       final faceRect =
// //           _reflectionRect(reflection, face.boundingBox, imageSize.width);
// //       canvas.drawRect(
// //         _scaleRect(
// //           rect: faceRect,
// //           imageSize: imageSize,
// //           widgetSize: size,
// //         ),
// //         paint,
// //       );
// //     }
// //   }

// //   @override
// //   bool shouldRepaint(FaceDetectorPainter oldDelegate) {
// //     return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
// //   }
// // }

// // Rect _reflectionRect(bool reflection, Rect boundingBox, double width) {
// //   if (!reflection) {
// //     return boundingBox;
// //   }
// //   final centerX = width / 2;
// //   final left = ((boundingBox.left - centerX) * -1) + centerX;
// //   final right = ((boundingBox.right - centerX) * -1) + centerX;
// //   return Rect.fromLTRB(left, boundingBox.top, right, boundingBox.bottom);
// // }

// // Rect _scaleRect({
// //   @required Rect rect,
// //   @required Size imageSize,
// //   @required Size widgetSize,
// // }) {
// //   final scaleX = widgetSize.width / imageSize.width;
// //   final scaleY = widgetSize.height / imageSize.height;

// //   final scaledRect = Rect.fromLTRB(
// //     rect.left.toDouble() * scaleX,
// //     rect.top.toDouble() * scaleY,
// //     rect.right.toDouble() * scaleX,
// //     rect.bottom.toDouble() * scaleY,
// //   );
// //   return scaledRect;
// // }
