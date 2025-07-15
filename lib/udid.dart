import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<String?> getDeviceUDID() async {
  final deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.id; // OR androidInfo.androidId (more stable)
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    return iosInfo.identifierForVendor;
  } else {
    return null;
  }
}
