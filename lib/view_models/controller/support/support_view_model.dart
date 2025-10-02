import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gig/repository/support/support_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';

class SupportViewModel extends GetxController {
  final _api = SupportRepository();
  final subjectController = TextEditingController().obs;
  final messageController = TextEditingController().obs;

  RxBool loading = false.obs;

  void SupportApi() {
    loading.value = true;
    Map data = {
      'subject': subjectController.value.text,
      'message': messageController.value.text,
    };
    _api
        .supportApi(data)
        .then((value) {
          loading.value = false;

          if (value['status'] == true) {
            Utils.snakBar(
              'Support ',
              value['message'] ?? 'Support Email sent to admin successfully',
            );
            // Navigator.pop(context);
            Get.offAllNamed(RoutesName.screenHolderScreen);
            // Get.off(true);
          } else {
            Utils.snakBar(
              'Support Email',
              value['message'] ?? 'Something went wrong',
            );
          }
        })
        .onError((error, stackTrace) {
          loading.value = false;
          Utils.snakBar('Support feature is under Maintance',"");
        });
  }
}
