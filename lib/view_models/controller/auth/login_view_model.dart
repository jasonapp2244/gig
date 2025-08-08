import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../../repository/auth_repository/login_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';

class LoginVewModel extends GetxController {
  final _api = LoginRepository();
  UserPreference userPreference = UserPreference();
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  RxBool loading = false.obs;

  void loginApi() async {
    loading.value = true;
    Map data = {
      'email': emailController.value.text,
      'password': passwordController.value.text,
    };

    _api
        .loginApi(data)
        .then((value) async {
          loading.value = false;

          if (value['status'] == true) {
            Utils.snakBar('Login', value['message']);
          } else {
            print("Login failed: $value");
            print("Login failed: ${value['errors']}");
            Utils.snakBar('Login', value['errors'] ?? 'Something went wrong');
          }
          final _storage = FlutterSecureStorage();
          // Store auth token and user data
          await _storage.write(key: 'auth_token', value: value['token']);
          await _storage.write(key: 'user_name', value: value['user']['name']);
          await _storage.write(
            key: 'user_email',
            value: value['user']['email'],
          );
          await _storage.write(
            key: 'user_id',
            value: value['user']['id'].toString(),
          );
          await _storage.write(
            key: 'user_phone',
            value: value['user']['phone_number'],
          );
          
  

       
          Get.toNamed(RoutesName.home);
        })
        .onError((error, stackTrace) {
          loading.value = false;
          print('Login API error: ${error.toString()}');
          Utils.snakBar('Error', error.toString());
        });
  }

}
