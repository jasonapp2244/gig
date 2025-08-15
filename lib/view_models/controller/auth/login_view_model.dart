import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../models/auth/user_model.dart';
import '../../../repository/auth_repository/login_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';

class LoginVewModel extends GetxController {
  final _api = LoginRepository();
  UserPreference userPreference = UserPreference();
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  // final remeberMe= fa

  final confirmpasswordController = TextEditingController().obs;

  RxBool loading = false.obs;

  void loginApi() {
    loading.value = true;
    Map data = {
      'email': emailController.value.text,
      'password': passwordController.value.text,
    };

    _api
        .loginApi(data)
        .then((value) {
          loading.value = false;

          if (value['status'] == true) {
            if (value['user']['role_id'] == 2) {
              if (value['user']['business_status'] == 'active') {
                Utils.snakBar('Login', value['message']);
                userPreference.saveUser(UserModel.fromJson(value)).then((_) {
                  // Get.offAllNamed(RoutesName.bottomBar);
                });
              } else {
                Utils.snakBar('Verify OTP', value['message']);
                // Get.offAllNamed(RoutesName.waitingForApproval);
              }
            } else if (value['user']['role_id'] == 3) {
              Utils.snakBar('Login', value['message']);
              userPreference.saveUser(UserModel.fromJson(value)).then((_) {
                // Get.offAllNamed(RoutesName.userBottomBar);
              });
            } else {
              Utils.snakBar(
                'Unknown User',
                'App is only for users and vendors.',
              );
              Get.offAllNamed(RoutesName.loginScreen);
            }
          } else {
            print("Login failed: $value");
            print("Login failed: ${value['errors']}");
            Utils.snakBar('Login', value['errors'] ?? 'Something went wrong');
          }
        })
        .onError((error, stackTrace) {
          loading.value = false;
          print('Login API error: ${error.toString()}');
          Utils.snakBar('Error', error.toString());
        });
  }
}
