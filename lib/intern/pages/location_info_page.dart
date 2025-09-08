import 'dart:developer';

import 'package:afila_intern_presence/admin/cubit/office_data_cubit.dart';
import 'package:afila_intern_presence/common/message_widget.dart';
import 'package:afila_intern_presence/common/security_checker.dart';
import 'package:afila_intern_presence/widgets/elevated_button_custom.dart';
import 'package:afila_intern_presence/widgets/text_form_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationInfoPage extends StatefulWidget {
  const LocationInfoPage({super.key});

  @override
  State<LocationInfoPage> createState() => _LocationInfoPageState();
}

class _LocationInfoPageState extends State<LocationInfoPage> {
    TextEditingController latController = TextEditingController();
    TextEditingController longController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurentLocation();

  }

  Future<void> getCurentLocation() async {
    await Permission.location.request().then((value) => Geolocator.getCurrentPosition().then((value) {
      latController.text = value.latitude.toString();
    longController.text = value.longitude.toString();
    },));

    
    
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Lokasi Saya"),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormFieldCustom(
                  controller: latController,
                  label: "Latitude",
                  isEnabled: false,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormFieldCustom(
                  controller: longController,
                  label: "Longitude",
                  isEnabled: false,
                ),
              ],
            ) 
      )),
    );
  }
}
