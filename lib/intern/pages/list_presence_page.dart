import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:afila_intern_presence/intern/cubit/get_list_presence_cubit.dart';
import 'package:afila_intern_presence/widgets/circular_progress_custom.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListPresencePage extends StatefulWidget {
  const ListPresencePage({super.key});

  @override
  State<ListPresencePage> createState() => _ListPresencePageState();
}

class _ListPresencePageState extends State<ListPresencePage> {
  @override
  void initState() {
    super.initState();
    context.read<GetListPresenceCubit>().getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Riwayat Absensi'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<GetListPresenceCubit, GetListPresenceState>(
          builder: (context, state) {
            DMethod.log(state.toString(), prefix: "STATE HISTORY PRESENCE");
            if (state is GetListPresenceLoading) {
              return const Center(
                child: CircularProgressCustom(),
              );
            } else if (state is GetListPresenceFailed) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is GetListPresenceSuccess) {
              return ListView.separated(
                itemBuilder: (context, index) => state.data.isEmpty? Text("Data kosong") : Card(
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat.yMMMEd()
                                            .format(state.data[index].checkIn),
                                        style: TextStyle(color: blueColor),
                                      ),
                                      Text(
                                        state.data[index].status,
                                        style: TextStyle(color: blueColor),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: yellowColor,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_circle_down_rounded,
                                            size: 16,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            DateFormat('HH:mm:ss').format(state.data[index].checkIn),
                                            style: TextStyle(color: blueColor),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "|",
                                        style: TextStyle(color: yellowColor),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_circle_up_rounded,
                                            size: 16,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            state.data[index].statement=="checkout"
                                            ? DateFormat('HH:mm:ss').format(state.data[index].checkOut)
                                            : "-",
                                            style: TextStyle(color: blueColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                itemCount: state.data.length);
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}
