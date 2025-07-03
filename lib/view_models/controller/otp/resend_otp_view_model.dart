import 'package:get/get.dart';
import '../../../data/app_exceptions.dart';
import '../../../repository/otp/resend_otp_respository.dart';
import '../../../utils/utils.dart';

class ResendOtpViewModel extends GetxController {
  final _api = ResendOtpRepository();

  RxBool loading = false.obs;

  Future<void> resendOtpApi(userEmail) async {

  Map<String, String> data = {
    'email': userEmail.toString(),
  };

  _api.resendOtpApi(data).then((value) {
    loading.value = false;
    print('==========================>>>>>>>RESPONSE $value');

    if (value['status'] == true) {
      Utils.snakBar('OTP Send', value['message'] + ' $userEmail' ?? 'OTP Send to you email. Please check you email account');
      // Get.toNamed(RoutesName.loginScreen);
    } else {
      Utils.snakBar('OTP Error', value['error'] ?? 'Something went wrong.');
    }
  }).onError((error, stackTrace) {
    loading.value = false;

    String errorMessage = 'Something went wrong';
    if (error is InternetException || error is FetchDataException || error is RequestTimeout) {
      errorMessage = error.toString();
    }

    Utils.snakBar('Error', errorMessage);
  });
}

}
