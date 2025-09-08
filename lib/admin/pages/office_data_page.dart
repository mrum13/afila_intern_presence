import 'package:afila_intern_presence/admin/cubit/office_data_cubit.dart';
import 'package:afila_intern_presence/common/message_widget.dart';
import 'package:afila_intern_presence/widgets/elevated_button_custom.dart';
import 'package:afila_intern_presence/widgets/text_form_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfficeDataPage extends StatelessWidget {
  const OfficeDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController officeNameController =
        TextEditingController(text: "Afila Media Karya");
    TextEditingController latController = TextEditingController();
    TextEditingController longController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Office Data"),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: BlocBuilder<OfficeDataCubit, OfficeDataState>(
          builder: (context, state) {
            if (state is GetOfficeDataSuccess) {
              latController.text = state.data.lat;
              longController.text = state.data.long;
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormFieldCustom(
                  controller: officeNameController,
                  label: "Office Name",
                  isEnabled: false,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormFieldCustom(
                  controller: latController,
                  label: "Office Latitude",
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormFieldCustom(
                  controller: longController,
                  label: "Office Longitude",
                ),
                const SizedBox(
                  height: 24,
                ),
                BlocConsumer<OfficeDataCubit, OfficeDataState>(
                  listener: (context, state) {
                    if (state is SetOfficeDataSuccess) {
                      successMessage(context,
                          message: 'Data berhasil ditambah');
                    } else if (state is OfficeDataFailed) {
                      failedMessage(context, message: state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is OfficeDataLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ElevatedButtonCustom(
                        onTap: () {
                          if (latController.text.isEmpty ||
                              longController.text.isEmpty) {
                            failedMessage(context,
                                message: "Mohon lengkapi data terlebih dahulu");
                          } else {
                            context.read<OfficeDataCubit>().setData(
                                lat: latController.text,
                                long: longController.text);
                          }
                        },
                        text: "Save");
                  },
                )
              ],
            );
          },
        ),
      )),
    );
  }
}
