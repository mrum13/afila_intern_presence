import 'dart:io';

import 'package:afila_intern_presence/admin/cubit/create_employee_cubit.dart';
import 'package:afila_intern_presence/admin/cubit/create_user_cubit.dart';
import 'package:afila_intern_presence/admin/cubit/get_intern_data_cubit.dart';
import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:afila_intern_presence/common/message_widget.dart';
import 'package:afila_intern_presence/mlkit_services/face_detector_service.dart';
import 'package:afila_intern_presence/mlkit_services/face_recognition_service.dart';
import 'package:afila_intern_presence/mlkit_services/helper/convert_face.dart';
import 'package:afila_intern_presence/widgets/circular_progress_custom.dart';
import 'package:afila_intern_presence/widgets/elevated_button_custom.dart';
import 'package:afila_intern_presence/widgets/text_form_field_custom.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController =
      TextEditingController(text: "intern1234");
  XFile pickedFile = XFile("-");
  final picker = ImagePicker();
  final faceDetector = FaceDetectorService();
  final faceRecognition = FaceRecognitionService();
  var dataEmbed = "-";
  var convertFace = ConvertFace();
  bool isLoading = false;

  Future<void> _registerFace() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) {
      setState(() {
        isLoading = false;
      });
      return;
    } else {
      setState(() {
        isLoading = true;
      });
    }

    final face = await faceDetector.detectAndCropFace(File(picked.path));
    if (face == null) {
      failedMessage(context, message: "Tidak ada wajah terdeteksi");
      return;
    }

// ✅ convert face ke Float32List untuk MobileFaceNet
    final input = convertFace.imageToByteListFloat32(face);

// ✅ ambil embedding via FaceRecognitionService
    List<double> embedding = faceRecognition.getEmbedding(input);

    setState(() {
      pickedFile = picked;
      dataEmbed = embedding.toString();
    });

    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();
    faceRecognition.loadModel();
  }

  @override
  Widget build(BuildContext context) {
    emailController.text = "${nameController.text}@intern.com";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Tambah User"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              dataEmbed != "-"
                  ? ClipOval(
                      child: Image.file(
                      File(pickedFile.path),
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ))
                  : IconButton(
                      onPressed: () => _registerFace(),
                      icon: Icon(
                        Icons.account_circle,
                        color: tertiaryTextColor,
                        size: 200,
                      )),
              const SizedBox(
                height: 36,
              ),
              TextFormFieldCustom(
                controller: nameController,
                label: "Name",
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormFieldCustom(
                controller: emailController,
                label: "Email",
                isEnabled: false,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormFieldCustom(
                controller: passController,
                label: "Password",
                obscureText: true,
                isEnabled: false,
              ),
              const SizedBox(
                height: 24,
              ),
              MultiBlocListener(
                listeners: [
                  BlocListener<CreateUserCubit, CreateUserState>(
                      listener: (context, state) {
                    if (state is CreateUserError) {
                      failedMessage(context, message: state.message);
                    } else if (state is CreateUserSuccess) {
                      context.read<GetInternDataCubit>().getData();
                      successMessage(context,
                          message:
                              "Berhasil menambahkan ${emailController.text}");
                    }
                  }),
                  BlocListener<CreateEmployeeCubit, CreateEmployeeState>(
                    listener: (context, state) {
                      if (state is CreateEmployeeError) {
                        failedMessage(context, message: state.message);
                      } else if (state is CreateEmployeeSuccess) {
                        context.read<CreateUserCubit>().createUser(
                            email: emailController.text,
                            password: passController.text);
                      }
                    },
                  )
                ],
                child: BlocBuilder<CreateEmployeeCubit, CreateEmployeeState>(
                  builder: (context, state) {
                    if (state is CreateEmployeeLoading) {
                      return const Center(
                        child: CircularProgressCustom(),
                      );
                    }
                    return ElevatedButtonCustom(
                        onTap: () {
                          if (nameController.text == "" ||
                              passController.text == "") {
                            failedMessage(context,
                                message:
                                    "Mohon isi email dan password terlebih dahulu !");
                          } else {
                            context.read<CreateEmployeeCubit>().createEmployee(
                                name: nameController.text,
                                email: emailController.text,
                                embeddData: dataEmbed);
                          }
                        },
                        text: "Create User");
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
