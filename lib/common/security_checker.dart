import 'package:d_method/d_method.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:root_checker_plus/root_checker_plus.dart';

Future<bool> androidRootChecker() async {
  bool rootedCheck = false;
  try {
    rootedCheck = (await RootCheckerPlus.isRootChecker())!;
    return rootedCheck;
  } on PlatformException {
    rootedCheck = false;
    return rootedCheck;
  }
}

Future<bool> developerMode() async {
  bool devMode = false;
  try {
    devMode = (await RootCheckerPlus.isDeveloperMode())!;
    // return devMode;
    return false;
  } on PlatformException {
    devMode = false;
    return devMode;
  }
}

Future<bool> iosJailbreak() async {
  bool jailbreak = false;
  try {
    jailbreak = (await RootCheckerPlus.isJailbreak())!;
    return jailbreak;
  } on PlatformException {
    jailbreak = false;
    return jailbreak;
  }
}

Future<bool> isMockLocation() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      
    }
  }

  locationData = await location.getLocation();

  bool? isMock = locationData.isMock;

  return isMock!;
}

Future<double> getDistance({
  required double latOffice,
  required double longOffice,
  required double latCurrent,
  required double longCurrent
  
}) async {
  ///office lat long
  double startLatitude = latOffice;   /// Afila Lat
  double startLongitude = longOffice; ///Afila Long

  // Titik B (misalnya lokasi tujuan)
  double endLatitude = latCurrent;     // Surabaya
  double endLongitude = longCurrent;

  // Hitung jarak dalam meter
  double distanceInMeters = Geolocator.distanceBetween(
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
  );

  DMethod.log("Jarak: $distanceInMeters meter", prefix: "Distance");
  DMethod.log("Jarak: ${distanceInMeters/1000} km", prefix: "Distance");
  DMethod.log("$startLatitude, $startLongitude", prefix: "Office LatLong");
  DMethod.log("$endLatitude, $endLongitude", prefix: "Current LatLong");

  return distanceInMeters;
}
