import 'package:afila_intern_presence/admin/cubit/get_intern_data_cubit.dart';
import 'package:afila_intern_presence/admin/models/user_model.dart';
import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:afila_intern_presence/widgets/circular_progress_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
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
                        if (state.data[index].email.contains('@intern')){
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
                                            color: state.data[index].faceChar ==
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
          )
        ],
      )),
    );
  }
}
