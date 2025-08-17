import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gig/repository/auth_repository/reset_otp_repository.dart';

import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';

class ResetPasswordViewModel extends GetxController {
  final _api = ResetOtpRepository();
  final passwordController = TextEditingController().obs;
  final oldPasswordController = TextEditingController().obs;

  RxBool loading = false.obs;

  void resetPasswordApi() {
    loading.value = true;
    Map data = {
      'old_password': passwordController.value.text,
      'new_password': oldPasswordController.value.text,
    };

    _api
        .resetOtpApi(data)
        .then((value) {
          loading.value = false;

          if (value['status'] == true) {
            Utils.snakBar('Reset Password', value['message']);
            Get.offAllNamed(RoutesName.loginScreen);
          } else {
            print("Reset Password failed: $value");
            Utils.snakBar(
              'Reset Password',
              value['error'] ?? 'Something went wrong',
            );
          }
        })
        .onError((error, stackTrace) {
          loading.value = false;
          print('Reset Password API error: ${error.toString()}');
          Utils.snakBar('Reset Password API', error.toString());
        });
  }
}
