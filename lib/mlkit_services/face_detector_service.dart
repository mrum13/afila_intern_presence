import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class FaceDetectorService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  /// Deteksi wajah dan crop jadi image kecil
  Future<img.Image?> detectAndCropFace(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isEmpty) return null;

    final face = faces.first;
    final bytes = await imageFile.readAsBytes();
    img.Image? original = img.decodeImage(bytes);

    if (original == null) return null;

    final rect = face.boundingBox;
    img.Image cropped = img.copyCrop(
      original,
      x: rect.left.toInt(),
      y: rect.top.toInt(),
      width: rect.width.toInt(),
      height: rect.height.toInt(),
    );

    return cropped;
  }
}
