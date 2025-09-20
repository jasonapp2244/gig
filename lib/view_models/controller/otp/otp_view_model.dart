import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gig/view/screen_holder/screen_holder_screen.dart';
import '../../../data/app_exceptions.dart';
import '../../../repository/otp/otp_repository.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';
import '../../../models/auth/user_model.dart';

class OtpViewModel extends GetxController {
  final _api = OtpRepository();
  final otpVerificationController = TextEditingController().obs;
  UserPreference userPreference = UserPreference();

  RxBool loading = false.obs;
  String? _fcmToken;
  Future<String?> _getToken() async {
    await FirebaseMessaging.instance.requestPermission();

    String? token = await FirebaseMessaging.instance.getToken();
    _fcmToken = token;

    print("✅ FCM Token: $token");
    return token;
  }

  Future<void> otpApi(String email) async {
    loading.value = true;
    String? token = await _getToken();
    Map<String, String> data = {
      'email': email,
      'otp': otpVerificationController.value.text,
      'fcm_token': token.toString(),
    };

    _api
        .otpApi(data)
        .then((value) async {
          loading.value = false;

          if (value['status'] == true) {
            Utils.snakBar(
              'OTP Verification',
              value['message'] ?? 'OTP Verified successfully!',
            );

            // Store token securely
            final _storage = FlutterSecureStorage();

            // Store auth token and user data
            await _storage.write(key: 'auth_token', value: value['token']);
            await _storage.write(
              key: 'user_name',
              value: value['user']['name'],
            );
            await _storage.write(
              key: 'user_email',
              value: value['user']['email'],
            );
            await _storage.write(
              key: 'user_id',
              value: value['user']['id'].toString(),
            );
            await _storage.write(
              key: 'user_phone',
              value: value['user']['phone_number'],
            );
            // Read back and print
            String? token = await _storage.read(key: 'auth_token');
            String? name = await _storage.read(key: 'user_name');
            String? email = await _storage.read(key: 'user_email');
            String? id = await _storage.read(key: 'user_id');
            String? phone = await _storage.read(key: 'user_phone');

            print('Token: $token');
            print('Name: $name');
            print('Email: $email');
            print('User ID: $id');
            print('Phone: $phone');

            // Update user preference with verified user data
            await userPreference.saveUser(UserModel.fromJson(value));

            // Navigate to home screen
            Get.to(ScreenHolderScreen());
          } else {
            Utils.snakBar(
              'OTP Error',
              value['message'] ?? 'OTP verification failed',
            );
          }
        })
        .onError((error, stackTrace) {
          loading.value = false;
          print("OTP Verification Error: $error");

          String errorMessage = 'Something went wrong';
          if (error is InternetException ||
              error is FetchDataException ||
              error is RequestTimeout) {
            errorMessage = error.toString();
          }

          Utils.snakBar('Error', errorMessage);
        });
  }
}
