import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_exceptions.dart';
import '../../../repository/otp/otp_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';

class OtpViewModel extends GetxController {
  final _api = OtpRepository();
  final otpVerificationController = TextEditingController().obs;

  RxBool loading = false.obs;




  Future<void> otpApi() async {
  loading.value = true;

  Map<String, String> data = {
    'otp': otpVerificationController.value.text,
  };

  _api.otpApi(data).then((value) {
    loading.value = false;
    print('==========================>>>>>>>RESPONSE $value');

    if (value['status'] == true) {

      Utils.snakBar('OTP Verification', value['message'] ?? 'OTP Verified successful!');

      if (value['user']['role_id'] == 2) {
        // Get.offAllNamed(RoutesName.waitingForApproval);
      }
      else {
          Get.toNamed(RoutesName.loginScreen);
      }
    }
    else {
      Utils.snakBar('OTP Error', value['message']);
    }
  }).onError((error, stackTrace) {
    loading.value = false;
    print("OTP Verification Error: $error");

    String errorMessage = 'Something went wrong';
    if (error is InternetException || error is FetchDataException || error is RequestTimeout) {
      errorMessage = error.toString();
    }

    Utils.snakBar('Error', errorMessage);
  });
}



}
