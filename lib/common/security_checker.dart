import 'package:flutter/services.dart';
import 'package:root_checker_plus/root_checker_plus.dart';
import 'package:trust_location/trust_location.dart';

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
    return devMode;
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
  // List<String?> position = await TrustLocation.getLatLong;

  /// check mock location on Android device.
  bool isMockLocation = await TrustLocation.isMockLocation;

  return isMockLocation;
}