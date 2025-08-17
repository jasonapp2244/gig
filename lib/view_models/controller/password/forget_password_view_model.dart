import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../repository/password/forget_password_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';

class ForgetPasswordVewModel extends GetxController {
  final _api = ForgetPasswordRepository();
  final emailController = TextEditingController().obs;

  RxBool loading = false.obs;

  void forgetPasswordApi() {
    loading.value = true;
    Map data = {'email': emailController.value.text};

    _api
        .forgetPasswordApi(data)
        .then((value) {
          loading.value = false;

          if (value['status'] == true) {
            Utils.snakBar(
              'OTP Sent',
              value['message'] ?? 'One Time Password sent to you email',
            );
            Get.offAllNamed(RoutesName.loginScreen);
          } else {
            print("Forget Password failed: $value");
            Utils.snakBar(
              'Forget Password',
              value['error'] ?? 'Something went wrong',
            );
          }
        })
        .onError((error, stackTrace) {
          loading.value = false;
          print('Forget Password API error: ${error.toString()}');
          Utils.snakBar('Forget Password API', error.toString());
        });
  }
}
