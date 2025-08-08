import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../../models/auth/user_model.dart';
import '../../../repository/auth_repository/register_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';

class RegisterVewModel extends GetxController {
  final _api = RegisterRepository();
  UserPreference userPreference = UserPreference();
  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final phoneNumberController = TextEditingController().obs;

  RxBool loading = false.obs;

  bool validateFields() {
    if (nameController.value.text.trim().isEmpty) {
      Utils.snakBar('Validation Error', 'Name is required');
      return false;
    }
    if (emailController.value.text.trim().isEmpty) {
      Utils.snakBar('Validation Error', 'Email is required');
      return false;
    }
    if (passwordController.value.text.trim().isEmpty) {
      Utils.snakBar('Validation Error', 'Password is required');
      return false;
    }
    if (phoneNumberController.value.text.trim().isEmpty) {
      Utils.snakBar('Validation Error', 'Phone number is required');
      return false;
    }

    // Email validation
    if (!GetUtils.isEmail(emailController.value.text.trim())) {
      Utils.snakBar('Validation Error', 'Please enter a valid email');
      return false;
    }

    // Password validation (minimum 6 characters)
    if (passwordController.value.text.trim().length < 6) {
      Utils.snakBar(
        'Validation Error',
        'Password must be at least 6 characters',
      );
      return false;
    }

    return true;
  }

  void registerApi() async {
    if (!validateFields()) {
      return;
    }
    loading.value = true;
    Map data = {
      'name': nameController.value.text.trim(),
      'email': emailController.value.text.trim(),
      'password': passwordController.value.text.trim(),
      'phone_number': phoneNumberController.value.text.trim(),
    };

    _api
        .registerApi(data)
        .then((value) async {
          loading.value = false;

          if (value['status'] == true) {
            if (value['message'] == 'OTP sent to your email') {
              Utils.snakBar('Register', value['message']);

              // Store auth token and user data
              const storage = FlutterSecureStorage();
              await storage.write(
                key: 'user_email',
                value: value['data']['email'],
              );
              print("reguster.. ${value['data']['email']}");

              userPreference.saveUser(UserModel.fromJson(value)).then((_) {
                Get.toNamed(
                  RoutesName.otpScreen,
                  arguments: {
                    'email': emailController.value.text.trim(),
                    'user_data': value,
                  },
                );
              });
            }
          }
        })
        .onError((error, stackTrace) {
          loading.value = false;
          print('Register API error: ${error.toString()}');
          Utils.snakBar('Error', error.toString());
        });
  }
}
