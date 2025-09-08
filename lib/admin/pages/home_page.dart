import 'package:afila_intern_presence/admin/cubit/get_intern_data_cubit.dart';
import 'package:afila_intern_presence/admin/models/user_model.dart';
import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:afila_intern_presence/intern/cubit/get_list_presence_cubit.dart';
import 'package:afila_intern_presence/intern/models/presence_model.dart';
import 'package:afila_intern_presence/widgets/circular_progress_custom.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:one_clock/one_clock.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<DateTime> getTodayDates(List<DateTime> dates) {
      final now = DateTime.now();
      return dates
          .where((date) =>
              date.year == now.year &&
              date.month == now.month &&
              date.day == now.day)
          .toList();
    }

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang, ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Super Admin",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: blueColor),
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
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Intern",
                    style: TextStyle(fontSize: 24),
                  ),
                  InkWell(
                    onTap: () => context.read<GetInternDataCubit>().getData(),
                    child: Text(
                      "Lihat semua",
                      style: TextStyle(color: blueColor),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            BlocBuilder<GetInternDataCubit, GetInternDataState>(
              builder: (context, state) {
                if (state is GetInternDataLoading) {
                  return const Center(
                    child: CircularProgressCustom(),
                  );
                } else if (state is GetInternDataError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else if (state is GetInternDataSuccess) {
                  return SizedBox(
                    width: double.infinity,
                    height: 128,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        List<UserModel> internData = [];

                        for (var item in state.data) {
                          if (state.data[index].email.contains('@intern')) {
                            internData.add(item);
                          }
                        }
                        return Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle_rounded,
                                      size: 84,
                                      color: tertiaryTextColor,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          internData[index].name,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          internData[index].email,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          state.data[index].faceChar == "-"
                                              ? "Belum Verifikasi"
                                              : "Terverifikasi",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  state.data[index].faceChar ==
                                                          "-"
                                                      ? Colors.red
                                                      : Colors.green),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      itemCount: state.data.length,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Absen Hari ini",
                    style: TextStyle(fontSize: 24),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Lihat semua",
                      style: TextStyle(color: blueColor),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            BlocBuilder<GetListPresenceCubit, GetListPresenceState>(
              builder: (context, state) {
                if (state is GetListPresenceLoading) {
                  return const Center(
                    child: CircularProgressCustom(),
                  );
                } else if (state is GetListPresenceFailed) {
                  return Center(
                    child: Text(state.message),
                  );
                } else if (state is GetListPresenceSuccess) {
                  bool isSameDay(DateTime a, DateTime b) {
                    return a.year == b.year &&
                        a.month == b.month &&
                        a.day == b.day;
                  }

                  List<PresenceModel> filterToday(
                      List<PresenceModel> presences) {
                    DateTime today = DateTime.now();
                    return presences
                        .where((p) => isSameDay(p.checkIn, today))
                        .toList();
                  }

                  var allData = filterToday(state.data);

                  return SizedBox(
                    width: double.infinity,
                    height: 112,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => state.data.isEmpty
                            ? Text("Data kosong")
                            : Row(
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Card(
                                    shadowColor: blueColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_filled_rounded,
                                            size: 52,
                                            color: blueColor,
                                          ),
                                          const SizedBox(
                                            width: 18,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    allData[index].name,
                                                    style: TextStyle(
                                                        color: blueColor),
                                                  ),
                                                  Text(
                                                    " ${state.data[index].status}",
                                                    style: TextStyle(
                                                        color: blueColor),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_circle_down_rounded,
                                                    size: 16,
                                                    color: Colors.green,
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    DateFormat('HH:mm:ss')
                                                        .format(allData[index]
                                                            .checkIn),
                                                    style: TextStyle(
                                                        color: blueColor),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_circle_up_rounded,
                                                    size: 16,
                                                    color: Colors.red,
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    allData[index].statement ==
                                                            "checkout"
                                                        ? DateFormat('HH:mm:ss')
                                                            .format(
                                                                allData[index]
                                                                    .checkOut)
                                                        : "-",
                                                    style: TextStyle(
                                                        color: blueColor),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        itemCount: allData.length),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Data Kantor",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: blueColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Card(
                              shadowColor: yellowColor,
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Image.asset(
                                  "assets/img_logo_app.png",
                                  width: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24,),
                            Card(
                              color: yellowColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(
                                      "Datang : 09:00:00",
                                      style: TextStyle(color: whiteColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Card(
                              color: yellowColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(
                                      "Pulang : 17:00:00",
                                      style: TextStyle(color: whiteColor),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            "assets/img_location.png",
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ))
                      ],
                    ),
                  ),
                )),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      )),
    );
  }
}
