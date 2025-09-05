import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:afila_intern_presence/cubit/auth_cubit.dart';
import 'package:afila_intern_presence/intern/cubit/get_current_user_cubit.dart';
import 'package:afila_intern_presence/pages/login_page.dart';
import 'package:afila_intern_presence/widgets/elevated_button_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    String name = "-";
    String email = "-";

    return Scaffold(
      appBar: AppBar(
        title: Text('Akun'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: blueColor,
              shadowColor: yellowColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 86,
                      color: whiteColor,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    BlocBuilder<GetCurrentUserCubit, GetCurrentUserState>(
                      builder: (context, state) {
                        if (state is GetCurrentUserSuccess) {
                          name = state.data.name;
                          email = state.data.email;
                        }
                        return Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style:
                                    TextStyle(fontSize: 24, color: whiteColor),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                email,
                                style: TextStyle(color: whiteColor),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Informasi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {},
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.device_unknown_rounded,
                        size: 36,
                        color: blueColor,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Informasi device anda",
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {},
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.pin_drop_rounded,
                        size: 36,
                        color: blueColor,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Lokasi anda",
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Lainnya",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 24,
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is SingOut) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                }
              },
              builder: (context, state) {
                return ElevatedButtonCustom(
                    onTap: () {
                      context.read<AuthCubit>().signOut();
                    },
                    text: "Keluar");
              },
            )
          ],
        ),
      )),
    );
  }
}
