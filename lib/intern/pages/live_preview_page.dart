import 'package:afila_intern_presence/intern/pages/result_page.dart';
import 'package:afila_intern_presence/widgets/elevated_button_custom.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';

class LivePreviewPage extends StatefulWidget {
  const LivePreviewPage({super.key});

  @override
  State<LivePreviewPage> createState() => _LivePreviewPageState();
}

class _LivePreviewPageState extends State<LivePreviewPage> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  String _status = "Menunggu wajah...";

  final List<String> _steps = ["Senyum", "Hadap kiri", "Hadap kanan"];
  late List<String> _randomSteps;
  int _currentStepIndex = 0;
  bool _isPhotoTaken = false;
  bool _done = false;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initFaceDetector();

    _randomSteps = List.from(_steps)..shuffle(); // random urutan
    _randomSteps.add("Hadap depan");
  }

  @override
  void dispose() {
    if (_cameraController?.value.isStreamingImages ?? false) {
      _cameraController?.stopImageStream();
    }
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  void _initFaceDetector() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true, // aktifkan senyum & mata
        enableTracking: true,
      ),
    );
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    _cameraController!.startImageStream(_processCameraImage);

    if (mounted) setState(() {});
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting || _done) return;
    _isDetecting = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize =
          Size(image.width.toDouble(), image.height.toDouble());

      final InputImageRotation imageRotation = _rotationIntToImageRotation(
        _cameraController!.description.sensorOrientation,
      ); // sesuaikan dengan kamera
      final InputImageFormat inputImageFormat = InputImageFormat.nv21;

      final inputImageData = InputImageMetadata(
        rotation: imageRotation,
        bytesPerRow: image.planes[0].bytesPerRow,
        format: inputImageFormat,
        size: imageSize,
      );

      final inputImage =
          InputImage.fromBytes(bytes: bytes, metadata: inputImageData);

      final faces = await _faceDetector.processImage(inputImage);

      DMethod.log("faces = ${faces.length}");

      if (faces.isEmpty) {
        setState(() => _status = "Tidak ada wajah");
      }

      for (Face face in faces) {
        final smile = face.smilingProbability ?? 0.0;
        // final leftEye = face.leftEyeOpenProbability ?? 0.0;
        // final rightEye = face.rightEyeOpenProbability ?? 0.0;
        final yaw = face.headEulerAngleY ?? 0.0;

        String expected = _randomSteps[_currentStepIndex];
        String status = "Step: $expected";

        bool matched = false;

        if (expected == "Senyum") {
          if (smile > 0.7) {
            matched = true;
            _player.play(AssetSource("correct_step_sound.wav"));
          }
        } else if (expected == "Hadap kiri") {
          if (yaw > 30) {
            matched = true;
            _player.play(AssetSource("correct_step_sound.wav"));
          }
        } else if (expected == "Hadap kanan") {
          if (yaw < -30) {
            matched = true;
            _player.play(AssetSource("correct_step_sound.wav"));
          }
        } else if (expected == "Hadap depan") {
          if (yaw > -15 && yaw < 15) {
            matched = true;
            // _player.play(AssetSource("correct_step_sound.wav"));
          }
        }

        if (matched) {
          status += " ✅";
          if (_currentStepIndex < _randomSteps.length - 1) {
            _currentStepIndex++;
          } else {
            if (!_isPhotoTaken) {
              _isPhotoTaken = true;
              _done = true;
              Future.delayed(const Duration(seconds: 2)).then((value) {
                _player.play(AssetSource("correct_step_sound.wav"));
                _takePicture();
              });
            }
          }
        }

        setState(() => _status = status);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isDetecting = false;
    }
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      if (_cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }

      final XFile file = await _cameraController!.takePicture();

      // Tutup kamera biar tidak conflict dengan preview
      // await _cameraController!.dispose();

      // Arahkan ke halaman hasil foto
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(imageFile: File(file.path)),
        ),
      );
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Live preview"),
          // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.sync))],
        ),
        body:
            _cameraController == null || !_cameraController!.value.isInitialized
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(
                                  _cameraController!.description.lensDirection ==
                                          CameraLensDirection.front
                                      ? 3.1416
                                      : 0),
                              child: CameraPreview(_cameraController!)),
                          const SizedBox(height: 24),
                          Text(
                            "Urutan step: ${_randomSteps.join(" → ")}",
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButtonCustom(
                              onTap: () async {
                                final XFile file = await _cameraController!.takePicture();
                      
                                if (!context.mounted) return;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ResultPage(imageFile: File(file.path)),
                                  ),
                                );
                              },
                              text: "Bypass"),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ));
  }
}
