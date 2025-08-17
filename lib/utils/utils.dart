import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class Utils {
  FlutterSecureStorage storage = FlutterSecureStorage();
  static void fieldFocusChange(
    BuildContext context,
    FocusNode current,
    FocusNode nextFocus,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void snakBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.white, // 👈 Background color white
      colorText: Colors.black, // 👈 Text ka color black takay visible ho
      snackPosition: SnackPosition.TOP, // (optional) kahaan show karna hai
      margin: const EdgeInsets.all(10), // (optional) thoda margin dena
      borderRadius: 10, // (optional) halki rounding
    );
  }

  Future<void> writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static Future<String?> readSecureData(String key) async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: key);
  }

  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  // Static method for writing secure storage
  static Future<void> writeSecureStorage(String key, String value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  // Get and print device ID
  static Future<String?> getAndPrintDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String? deviceId;

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id; // Android ID
        print(deviceId);
        print('📱 Android Device ID: $deviceId');

        print('📱 Android Device Model: ${androidInfo.model}');
        print('📱 Android Device Brand: ${androidInfo.brand}');
        print('📱 Android Device Manufacturer: ${androidInfo.manufacturer}');
        print('📱 Android Device Fingerprint: ${androidInfo.fingerprint}');
        ;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor; // iOS Vendor ID
        print('📱 iOS Device ID: $deviceId');
        print('📱 iOS Device Model: ${iosInfo.model}');
        print('📱 iOS Device Name: ${iosInfo.name}');
        print('📱 iOS Device System Name: ${iosInfo.systemName}');
        print('📱 iOS Device System Version: ${iosInfo.systemVersion}');
      }

      return deviceId;
    } catch (e) {
      print('❌ Error getting device ID: $e');
      return null;
    }
  }

  // Simple method to just get device ID without extra info
  static Future<String?> getDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      }

      return null;
    } catch (e) {
      print('Error getting device ID: $e');
      return null;
    }
  }

  static Future<String?> getAndPrintFCMToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // On Android (especially Android 13+), request notification permission
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print('🔥 FCM Permission Status: ${settings.authorizationStatus}');
      // Fallback for stubborn OEMs
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        if (await Permission.notification.isDenied) {
          await Permission.notification.request();
        }

        if (settings.authorizationStatus == AuthorizationStatus.denied) {
          print('🚫 Notification permission denied');
          return null;
        }

        // Get the FCM token
        String? token = await messaging.getToken();

        if (token != null) {
          print('🔥 FCM TOKEN RETRIEVED SUCCESSFULLY! 🔥');
          print('=' * 80);
          print('📱 DEVICE FCM TOKEN:');
          print(token);
          print('=' * 80);

          return token;
        } else {
          print('❌ Failed to get FCM token');
          return null;
        }
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
      return null;
    }
  }

  // Get FCM token without extra printing (simple version)
  static Future<String?> getFCMToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      String? token = await messaging.getToken();
      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  // Listen to FCM token refresh
  static void listenToFCMTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('🔄 FCM Token refreshed: $newToken');
      writeSecureStorage('fcm_token', newToken);
    });
  }

  // Get stored FCM token from secure storage
  static Future<String?> getStoredFCMToken() async {
    try {
      String? token = await readSecureData('fcm_token');
      if (token != null) {
        print('📱 Stored FCM Token: $token');
      } else {
        print('❌ No FCM token found in storage');
      }
      return token;
    } catch (e) {
      print('Error reading stored FCM token: $e');
      return null;
    }
  }

  // Clear all user data from storage
  Future<void> clearUserData() async {
    final _storage = FlutterSecureStorage();

    // Clear all secure storage keys
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_name');
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'user_phone');

    // Clear user preferences
    // await userPreference.clearUser();
  }
}
