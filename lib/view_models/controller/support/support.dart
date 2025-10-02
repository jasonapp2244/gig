import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/repository/support/support_repository.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:gig/utils/utils.dart';

class SupportViewModel extends GetxController {
  final _api = SupportRepository();
  final subject = TextEditingController().obs;
  final message = TextEditingController().obs;


  RxBool loading = false.obs;

  void SupportApi() {
    loading.value = true;
    Map data = {'subject': subject.value.text,'message': subject.value.text};

    _api
        .supportApi(data)
        .then((value) {
          loading.value = false;

          if (value['status'] == true) {
            Utils.snakBar(
              'Support Request',
              value['message'] ?? 'Support Request send successfully',
            );
            Get.offAllNamed(RoutesName.loginScreen);
          } else {
            print("Support Request failed: $value");
            Utils.snakBar(
              'Support Request',
              value['error'] ?? 'Something went wrong',
            );
          }
        })
        .onError((error, stackTrace) {
          loading.value = false;
          print('Support Request API error: ${error.toString()}');
          Utils.snakBar('Support Request Api', error.toString());
        });
  }
}
