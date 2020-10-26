// import 'dart:async';
// // import 'dart:html';
// import 'dart:io';
// import 'dart:math';

// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:image_picker/image_picker.dart';

// final ImagePicker _picker = ImagePicker();
// // File imageFile;

// Future<File> getImage() async {
//   try {
//     final PickedFile pickedImage =
//         await _picker.getImage(source: ImageSource.gallery);
//     final File imageFile = File(pickedImage.path);
//     return imageFile;
//   } catch (e) {
//     print('$e, ${e.code}');
//   }
//   return null;
// }

// final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
// final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();

// Future<void> detectFace(File imageFile) async {
//   final FirebaseVisionImage visionImage =
//       FirebaseVisionImage.fromFile(imageFile);
//   final List<Face> faces = await faceDetector.processImage(visionImage);

//   for (Face face in faces) {
//     final Rectangle<int> boundingBox = face.boundingBox as Rectangle<int>;

//     final double rotY =
//         face.headEulerAngleY; // Head is rotated to the right rotY degrees
//     final double rotZ =
//         face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

//     // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
//     // eyes, cheeks, and nose available):
//     final FaceLandmark leftEar = face.getLandmark(FaceLandmarkType.leftEar);
//     if (leftEar != null) {
//       final Point<double> leftEarPos = leftEar.position as Point<double>;
//     }

//     // If classification was enabled with FaceDetectorOptions:
//     if (face.smilingProbability != null) {
//       final double smileProb = face.smilingProbability;
//     }

//     // If face tracking was enabled with FaceDetectorOptions:
//     if (face.trackingId != null) {
//       final int id = face.trackingId;
//     }
//   }
// }

// Future<void> detectImage(File imageFile) async {
//   final FirebaseVisionImage visionImage =
//       FirebaseVisionImage.fromFile(imageFile);
//   final List<ImageLabel> labels = await labeler.processImage(visionImage);
// }
