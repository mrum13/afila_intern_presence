import 'package:afila_intern_presence/admin/cubit/office_data_cubit.dart';
import 'package:afila_intern_presence/admin/pages/office_data_page.dart';
import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:afila_intern_presence/intern/cubit/get_current_user_cubit.dart';
import 'package:afila_intern_presence/widgets/elevated_button_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    String name = "Super Admin";
    String email = "afila@admin.com";
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              
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
                        Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: 24, color: whiteColor),
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
                            )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButtonCustom(
                    onTap: () {
                      context.read<OfficeDataCubit>().getData();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OfficeDataPage(),
                          ));
                    },
                    text: "Office Data"),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButtonCustom(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    text: "Logout"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
