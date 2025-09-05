import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:afila_intern_presence/intern/cubit/get_current_user_cubit.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:one_clock/one_clock.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  String userName = "-";

  @override
  void initState() {
    super.initState();
    DMethod.log("Init State", prefix: 'Lifecycle');
  }

  @override
  void deactivate() {
    DMethod.log("Deactivate", prefix: 'Lifecycle');
    super.deactivate();
  }

  @override
  void dispose() {
    DMethod.log("Dispose", prefix: 'Lifecycle');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang, ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 4,
            ),
            BlocBuilder<GetCurrentUserCubit, GetCurrentUserState>(
              builder: (context, state) {
                if (state is GetCurrentUserSuccess) {
                  userName = state.data.name;
                }
                return Text(
                  userName,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: blueColor),
                );
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat.yMMMEd().format(DateTime.now())),
                DigitalClock(
                    showSeconds: true,
                    isLive: true,
                    digitalClockTextColor: Colors.black,
                    datetime: DateTime.now())
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Text("Absen hari ini",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            const SizedBox(height: 8,),
            Card(
              color: blueColor,
              shadowColor: yellowColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Absen Datang",
                      style: TextStyle(
                          color: whiteColor, fontWeight: FontWeight.w500),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "09:00:00",
                          style: TextStyle(color: whiteColor),
                        ),
                        Text(
                          "|",
                          style: TextStyle(color: yellowColor),
                        ),
                        Text(
                          "00:00:00",
                          style: TextStyle(color: yellowColor),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Card(
              color: blueColor,
              shadowColor: yellowColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Absen Pulang",
                      style: TextStyle(
                          color: whiteColor, fontWeight: FontWeight.w500),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "17:00:00",
                          style: TextStyle(color: whiteColor),
                        ),
                        Text(
                          "|",
                          style: TextStyle(color: yellowColor),
                        ),
                        Text(
                          "00:00:00",
                          style: TextStyle(color: yellowColor),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24,),
            Text("Lokasi absen",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            const SizedBox(height: 8,),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset("assets/img_location.png",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      )),
    );
  }
}
