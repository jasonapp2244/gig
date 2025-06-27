import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gig/repository/password/reset_password_repository.dart';

import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';

class ResetPasswordViewModel extends GetxController {
  final _api = ResetPasswordRepository();
  final passwordController = TextEditingController().obs;
  final oldPasswordController = TextEditingController().obs;

  RxBool loading = false.obs;

  void resetPasswordApi() {
    loading.value = true;
    Map data = {
      'password': passwordController.value.text,
      'old_password': oldPasswordController.value.text,
    };

    _api
        .resetPasswordApi(data)
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
