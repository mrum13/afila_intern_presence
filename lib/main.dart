import 'package:afila_intern_presence/admin/cubit/create_employee_cubit.dart';
import 'package:afila_intern_presence/admin/cubit/create_user_cubit.dart';
import 'package:afila_intern_presence/admin/cubit/get_intern_data_cubit.dart';
import 'package:afila_intern_presence/admin/pages/create_user_page.dart';
import 'package:afila_intern_presence/admin/pages/main_page.dart' as adminmainpage;
import 'package:afila_intern_presence/cubit/navbar_cubit.dart';
import 'package:afila_intern_presence/intern/cubit/get_current_user_cubit.dart';
import 'package:afila_intern_presence/intern/cubit/get_list_presence_cubit.dart';
import 'package:afila_intern_presence/intern/pages/live_preview_page.dart';
import 'package:afila_intern_presence/intern/pages/main_page.dart' as internmainpage;
import 'package:afila_intern_presence/intern/pages/result_page.dart';
import 'package:afila_intern_presence/lecture/pages/main_page.dart' as lecturemainpage;
import 'package:afila_intern_presence/cubit/auth_cubit.dart';
import 'package:afila_intern_presence/firebase_options.dart';
import 'package:afila_intern_presence/pages/login_page.dart';
import 'package:afila_intern_presence/services/firebase_auth_service.dart';
import 'package:afila_intern_presence/services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseFirestore = FirebaseFirestore.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(FirebaseAuthService(firebaseAuth)),
        ),
        BlocProvider(
          create: (context) => NavbarCubit(),
        ),
        BlocProvider(
          create: (context) => CreateUserCubit(FirebaseAuthService(firebaseAuth)),
        ),
        BlocProvider(
          create: (context) => GetInternDataCubit(FirebaseFirestoreService(firebaseFirestore)),
        ),
        BlocProvider(
          create: (context) => GetCurrentUserCubit(FirebaseFirestoreService(firebaseFirestore)),
        ),
        BlocProvider(
          create: (context) => CreateEmployeeCubit(FirebaseFirestoreService(firebaseFirestore)),
        ),
        BlocProvider(
          create: (context) => GetListPresenceCubit(FirebaseFirestoreService(firebaseFirestore)),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => const LoginPage(),
          '/main-page-admin': (context) => const adminmainpage.MainPage(),
          '/main-page-intern': (context) => const internmainpage.MainPage(),
          '/create-user': (context) => const CreateUserPage(),
          '/live-preview': (context) => const LivePreviewPage(),
        },
      ),
    );
  }
}
