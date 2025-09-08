import 'dart:convert';
import 'dart:io';

import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:afila_intern_presence/common/message_widget.dart';
import 'package:afila_intern_presence/common/option_presence.dart';
import 'package:afila_intern_presence/common/security_checker.dart';
import 'package:afila_intern_presence/intern/cubit/get_list_presence_cubit.dart';
import 'package:afila_intern_presence/intern/cubit/presence_cubit.dart';
import 'package:afila_intern_presence/intern/pages/main_page.dart';
import 'package:afila_intern_presence/mlkit_services/face_detector_service.dart';
import 'package:afila_intern_presence/mlkit_services/face_recognition_service.dart';
import 'package:afila_intern_presence/mlkit_services/helper/convert_face.dart';
import 'package:afila_intern_presence/common/storage_service.dart';
import 'package:afila_intern_presence/widgets/circular_progress_custom.dart';
import 'package:afila_intern_presence/widgets/elevated_button_custom.dart';
import 'package:d_method/d_method.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

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

    final face = await faceDetector.detectAndCropFace(File(pickedFile.path));
    if (face == null) {
      if (!mounted) return;
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

    if (similarity > 0.8) {
      setState(() {
        isSimillar = true;
      });
    } else {
      setState(() {
        isSimillar = false;
      });
    }

    if (similarity < 0.8) {
      if (!mounted) return;
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
      ).then((value) {
        if (!mounted) return;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ));
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> isInsideArea() async {
    var officeData = await StorageService.getOfficeLatLong();
    var decodedData = jsonDecode(officeData);
    var currentLocation = await Geolocator.getCurrentPosition();

    var data = await getDistance(
      latOffice: double.parse(decodedData['lat']), 
      longOffice: double.parse(decodedData['long']), 
      latCurrent: currentLocation.latitude,
      longCurrent: currentLocation.longitude
    );
    
    if (data <= 6) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    isInsideArea();
    faceRecognition.loadModel().then((value) => _verifyFace(widget.imageFile));
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime tenAM = DateTime(now.year, now.month, now.day, 10, 0);

    Future<dartz.Either<bool, String>> deviceCheck() async {
      if (Platform.isAndroid) {
        bool rootChecker = await androidRootChecker();
        bool devModeChecker = await developerMode();
        if (rootChecker) {
          return dartz.Right('Device anda tidak bisa digunakan karena ROOT');
        } else if (devModeChecker) {
          return dartz.Right('Matikan opsi pengembang terlebih dahulu');
        } else {
          return dartz.Left(true);
        }
      } else {
        bool isJailbreak = await iosJailbreak();
        if (isJailbreak) {
          return dartz.Right('Device anda tidak bisa digunakan karena JAILBREAK');
        } else {
          return dartz.Left(true);
        }
      }
    }

    Future<bool> isMockLocationChecker() async {
      return await isMockLocation();
    }



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
                              ).then((value) {
                                if (!context.mounted) return;
                                context.read<GetListPresenceCubit>().getData();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainPage(),
                                    ));
                              });
                            } else if (state is PresenceFailed) {
                              failedMessage(context, message: state.message);
                            }
                          },
                          builder: (context, state) {
                            if (state is PresenceLoading || state is DeviceChecking) {
                              return const CircularProgressCustom();
                            }
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButtonCustom(
                                  onTap: () async {
                                    context.read<PresenceCubit>().deviceChecking();
                                    final result = await deviceCheck();
                                    result.fold(
                                      (l) async {
                                        final isMock = await isMockLocationChecker();
                                        if (isMock) {
                                          if (!context.mounted) return;
                                          failedMessage(context,
                                              message:
                                                  "Anda menggunakan lokasi palsu !");
                                        } else {
                                          
                                          var isInside  = await isInsideArea();
                                          if (currentOption=='Hadir' && !isInside) {
                                            if (!context.mounted) return;
                                            failedMessage(context, message: "Anda berada diluar area kerja !");
                                          } else {
                                            if (!context.mounted) return;
                                            context
                                              .read<PresenceCubit>()
                                              .presence(
                                                  presenceStatement:
                                                      DateTime.now()
                                                              .isAfter(tenAM)
                                                          ? "checkout"
                                                          : "checkin",
                                                  status: currentOption,
                                                  checkInTime:
                                                      DateTime.now().toString(),
                                                  checkOutTime: DateTime.now()
                                                      .toString());
                                          }
                                          
                                        }
                                      },
                                      (r) => failedMessage(context, message: r),
                                    );
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
