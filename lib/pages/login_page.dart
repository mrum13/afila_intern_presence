import 'package:afila_intern_presence/admin/cubit/get_intern_data_cubit.dart';
import 'package:afila_intern_presence/admin/cubit/office_data_cubit.dart';
import 'package:afila_intern_presence/common/message_widget.dart';
import 'package:afila_intern_presence/cubit/auth_cubit.dart';
import 'package:afila_intern_presence/cubit/navbar_cubit.dart';
import 'package:afila_intern_presence/intern/cubit/get_current_user_cubit.dart';
import 'package:afila_intern_presence/intern/cubit/get_list_presence_cubit.dart';
import 'package:afila_intern_presence/widgets/circular_progress_custom.dart';
import 'package:afila_intern_presence/widgets/elevated_button_custom.dart';
import 'package:afila_intern_presence/widgets/text_form_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController(text: "afila@admin.com");
    TextEditingController passController = TextEditingController(text: "admin1234");

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/img_logo_app.png",
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "Login",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormFieldCustom(
                controller: emailController, 
                label: "Email",
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormFieldCustom(
                controller: passController, 
                label: "Password",
                obscureText: true,
              ),
              const SizedBox(
                height: 24,
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    failedMessage(context, message: state.message);
                  } else if (state is AuthSuccess) {
                    String role = "-";
                    role = state.email;

                    context.read<NavbarCubit>().setIndexPage(index: 0);
                    if (role.contains("@admin")) {
                      context.read<GetCurrentUserCubit>().getData(docId: role);
                      context.read<GetInternDataCubit>().getData();
                      context.read<GetListPresenceCubit>().getData(isAdmin: true);
                      Navigator.pushNamed(context, '/main-page-admin');
                    } else if (role.contains("@intern")) {
                      context.read<GetCurrentUserCubit>().getData(docId: role);
                      context.read<GetListPresenceCubit>().getData();
                      context.read<OfficeDataCubit>().getData();
                      Navigator.pushNamed(context, '/main-page-intern');
                    } else {}
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(
                      child: CircularProgressCustom(),
                    );
                  }
                  return ElevatedButtonCustom(
                      onTap: () {
                        if (emailController.text == "" ||
                            passController.text == "") {
                          failedMessage(context,
                              message:
                                  "Mohon isi email dan password terlebih dahulu !");
                        } else {
                          context.read<AuthCubit>().signIn(
                              email: emailController.text,
                              password: passController.text);
                        }
                      },
                      text: "Masuk");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
