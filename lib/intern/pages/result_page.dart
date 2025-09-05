import 'dart:io';

import 'package:afila_intern_presence/intern/pages/main_page.dart';
import 'package:afila_intern_presence/mlkit_services/face_detector_service.dart';
import 'package:afila_intern_presence/mlkit_services/face_recognition_service.dart';
import 'package:afila_intern_presence/mlkit_services/helper/convert_face.dart';
import 'package:afila_intern_presence/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ResultPage extends StatefulWidget {
  final File imageFile;

  const ResultPage({super.key, required this.imageFile});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final faceDetector = FaceDetectorService();
  final faceRecognition = FaceRecognitionService();

  Future<void> _verifyFace(File pickedFile) async {
    var savedEmbedding = await StorageService.getFaces();
    if (savedEmbedding == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Belum ada wajah yang terdaftar")));
      return;
    }

    final face = await faceDetector.detectAndCropFace(File(pickedFile.path));
    if (face == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Tidak ada wajah terdeteksi")));
      return;
    }

    final resized = img.copyResize(face, width: 112, height: 112);

    // ✅ konversi ke Float32List
    final input = ConvertFace().imageToByteListFloat32(resized);

    // ✅ ambil embedding (192 dimensi)
    final embedding = faceRecognition.getEmbedding(input);


    // ✅ hitung cosine similarity
    final similarity = faceRecognition.cosineSimilarity(
        savedEmbedding,
        embedding);

    String result = similarity > 0.8
        ? "Wajah cocok ✅ ($similarity)"
        : "Wajah tidak cocok ❌ ($similarity)";

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    faceRecognition.loadModel().then((value) => _verifyFace(widget.imageFile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Foto")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(widget.imageFile),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ));
              },
              child: Text("Kembali ke Home"))
        ],
      )),
    );
  }
}
