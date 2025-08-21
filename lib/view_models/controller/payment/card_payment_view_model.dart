import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../repository/payment/card_payment_repository.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';

class CardPaymentViewModel extends GetxController {
  final _api = CardPaymentRepository();
  UserPreference userPreference = UserPreference();
  final cardHolderNameController = TextEditingController().obs;
  final cardNumberController = TextEditingController().obs;
  final expMonthController = TextEditingController().obs;
  final expYearController = TextEditingController().obs;
  final cvcController = TextEditingController().obs;

  RxBool loading = false.obs;

  void cardPaymentApi() {
    loading.value = true;
    Map data = {
      'card_holder_name': cardHolderNameController.value.text,
      'card_number': cardNumberController.value.text,
    };

    _api
        .cardPaymentApi(data)
        .then((value) {
          loading.value = false;

          if (value['status'] == true) {
            //Route to another page
          } else {
            print("Payment failed: $value");
            print("Payment failed: ${value['errors']}");
            Utils.snakBar('Payment', value['errors'] ?? 'Something went wrong');
          }
        })
        .onError((error, stackTrace) {
          loading.value = false;
          print('Payment API error: ${error.toString()}');
          Utils.snakBar('Error', error.toString());
        });
  }
}
