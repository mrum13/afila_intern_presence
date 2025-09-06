import 'dart:io';

import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:afila_intern_presence/common/message_widget.dart';
import 'package:afila_intern_presence/common/option_presence.dart';
import 'package:afila_intern_presence/intern/cubit/get_list_presence_cubit.dart';
import 'package:afila_intern_presence/intern/cubit/presence_cubit.dart';
import 'package:afila_intern_presence/intern/pages/main_page.dart';
import 'package:afila_intern_presence/mlkit_services/face_detector_service.dart';
import 'package:afila_intern_presence/mlkit_services/face_recognition_service.dart';
import 'package:afila_intern_presence/mlkit_services/helper/convert_face.dart';
import 'package:afila_intern_presence/common/storage_service.dart';
import 'package:afila_intern_presence/widgets/circular_progress_custom.dart';
import 'package:afila_intern_presence/widgets/elevated_button_custom.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultPage extends StatefulWidget {
  final File imageFile;

  const ResultPage({super.key, required this.imageFile});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final faceDetector = FaceDetectorService();
  final faceRecognition = FaceRecognitionService();
  bool isSimillar = false;
  String currentOption = options[0];
  bool isLoading = true;

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
    final similarity =
        faceRecognition.cosineSimilarity(savedEmbedding, embedding);

    String result = "-";

    if (similarity > 0.8) {
      setState(() {
        isSimillar = true;
      });
      result = "Wajah cocok ✅ ($similarity)";
    } else {
      setState(() {
        isSimillar = false;
      });
      result = "Wajah tidak cocok ❌ ($similarity)";
    }

    if (similarity < 0.8) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 36,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text("Wajah tidak sama !")
                  ],
                ),
              ),
            ),
          );
        },
      ).then(
        (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            )),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    faceRecognition.loadModel().then((value) => _verifyFace(widget.imageFile));
  }

  @override
  Widget build(BuildContext context) {
    // Waktu sekarang
    DateTime now = DateTime.now();

    // Buat jam 10:00 hari ini
    DateTime tenAM = DateTime(now.year, now.month, now.day, 10, 0);

    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Foto")),
      body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : !isSimillar
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                            child: Image.file(
                          widget.imageFile,
                          height: 300,
                          width: 300,
                          fit: BoxFit.cover,
                        )),
                        const SizedBox(
                          height: 24,
                        ),
                        ListTile(
                          title: const Text("Hadir"),
                          leading: Radio(
                            value: options[0],
                            groupValue: currentOption,
                            activeColor: blueColor,
                            onChanged: (value) {
                              setState(() {
                                currentOption = value.toString();
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Izin"),
                          leading: Radio(
                            value: options[1],
                            groupValue: currentOption,
                            activeColor: blueColor,
                            onChanged: (value) {
                              setState(() {
                                currentOption = value.toString();
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Sakit"),
                          leading: Radio(
                            value: options[2],
                            groupValue: currentOption,
                            activeColor: blueColor,
                            onChanged: (value) {
                              setState(() {
                                currentOption = value.toString();
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        BlocConsumer<PresenceCubit, PresenceState>(
                          listener: (context, state) {
                            if (state is PresenceSuccess) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.check_circle_rounded,
                                                color: Colors.green,
                                                size: 36,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text("Absen berhasil")
                                            ],
                                          ),
                                        ),
                                    ),
                                  );
                                },
                              ).then(
                                (value) {
                                  context.read<GetListPresenceCubit>().getData();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainPage(),
                                    ));
                                } 
                              );
                            } else if (state is PresenceFailed) {
                              failedMessage(context, message: state.message);
                            }
                          },
                          builder: (context, state) {
                            if (state is PresenceLoading) {
                              return const CircularProgressCustom();
                            }
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButtonCustom(
                                  onTap: () {
                                    context.read<PresenceCubit>().presence(
                                        presenceStatement:
                                            DateTime.now().isAfter(tenAM)
                                                ? "checkout"
                                                : "checkin",
                                        status: currentOption,
                                        checkInTime: DateTime.now().toString(),
                                        checkOutTime: DateTime.now().toString());
                                  },
                                  text: "Absen Sekarang"),
                            );
                          },
                        )
                      ],
                    )),
    );
  }
}
