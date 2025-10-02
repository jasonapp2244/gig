import 'package:get/get.dart';
import 'package:gig/repository/auth_repository/logout_repository.dart';
import 'package:gig/view/auth/auth_servies.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';

class LogoutViewModel extends GetxController {
  final _api = LogoutRepository();
  UserPreference userPreference = UserPreference();

  RxBool loading = false.obs;

  void logoutApi() async {
    // Get auth token from secure storage
    String? token = await Utils.readSecureData('auth_token');

    if (token == null || token.isEmpty) {
      Utils.snakBar('Error', 'No authentication token found');
      return;
    }

    loading.value = true;
    Map data = {'token': token};

    _api
        .logoutApi(data)
        .then((value) async {
          loading.value = false;
          try {
            if (value['status'] == true) {
              // Clear all stored data
              String providerName =
                  await Utils.readSecureData('provider_name') ?? '';
              if (providerName == 'google') {
                GoogleAuthRepository.signOut();
                await Utils().clearUserData();
              }
              await Utils().clearUserData();
              Utils.snakBar(
                'Logout',
                value['message'] ?? 'Logged out successfully',
              );

              // Navigate to login screen
              Get.offAllNamed(RoutesName.loginScreen);
            } else {
              await Utils().clearUserData();
              print("Logout failed: $value");
              Utils.snakBar(
                'Logout Error',
                value['message'] ?? 'Logout failed',
              );
            }
          } catch (e) {
            await Utils().clearUserData();
            print("error of logout $e");
          }
        })
        .onError((error, stackTrace) {
          loading.value = false;
          print('Logout API error: ${error.toString()}');
          Utils.snakBar('Error', error.toString());
        });
  }

  void logout() {
    logoutApi();
  }
}
