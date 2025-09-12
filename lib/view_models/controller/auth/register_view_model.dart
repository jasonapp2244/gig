import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gig/view_models/controller/otp/resend_otp_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    // Retry logic for registration
    int maxRetries = 3;
    int retryCount = 0;

   // while (retryCount < maxRetries) {
      try {
        print('🔄 Register attempt ${retryCount + 1} of $maxRetries');

        final value = await _api.registerApi(data);

        print('✅ Register successful on attempt ${retryCount + 1}');
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

            // Also store in SharedPreferences for OTP screen fallback
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('otp_email', value['data']['email']);

            print("register.. ${value['data']['email']}");

            userPreference.saveUser(UserModel.fromJson(value)).then((_) {
              Get.toNamed(
                RoutesName.otpScreen,
                arguments: {
                  'email': emailController.value.text.trim(),
                  'user_data': value,
                },
              );
            });
            return; // Success, exit retry loop
          }
        } else {
          String errorMsg = value['message'] ?? 'Something went wrong';

          // Check for email verification error first
          if (errorMsg.contains('verify your email')) {
            // Show the original backend error message
            Utils.snakBar('Register', errorMsg);
            final ResendOtpVM = Get.put(ResendOtpViewModel());
            ResendOtpVM.resendOtpApi();

            // Store email for OTP verification
            const storage = FlutterSecureStorage();
            await storage.write(
              key: 'user_email',
              value: emailController.value.text.trim(),
            );

            // Also store in SharedPreferences for OTP screen fallback
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(
              'otp_email',
              emailController.value.text.trim(),
            );

            // Navigate to OTP screen for email verification
            Get.toNamed(
              RoutesName.otpScreen,
              arguments: {
                'email': emailController.value.text.trim(),
                'user_data': value,
              },
            );
            return; // Exit retry loop for email verification
          } else if (value['errors'] != null && value['errors'] is Map) {
            Map<String, dynamic> errors = value['errors'];
            String detailedErrorMsg = '';

            // Combine all validation errors
            errors.forEach((field, errorList) {
              if (errorList is List) {
                for (String error in errorList) {
                  if (detailedErrorMsg.isNotEmpty) {
                    detailedErrorMsg += '\n';
                  }
                  detailedErrorMsg += error;
                }
              }
            });

            // Show the detailed validation errors from backend
            Utils.snakBar(
              'Register',
              detailedErrorMsg.isNotEmpty ? detailedErrorMsg : errorMsg,
            );
            return; // Exit retry loop for validation errors
          } else {
            // Show the general backend error message
            Utils.snakBar('Register', errorMsg);
            return; // Exit retry loop for general errors
          }
        }
      } catch (e) {
        retryCount++;
        print('❌ Register attempt $retryCount failed: ${e.toString()}');

        if (retryCount >= maxRetries) {
          print('❌ Max register retries reached, giving up');
          loading.value = false;

          // Provide specific error messages
          String errorMessage;
          if (e.toString().contains('TimeoutException')) {
            errorMessage =
                'Registration request timed out. Please check your internet connection and try again.';
          } else if (e.toString().contains('SocketException')) {
            errorMessage =
                'No internet connection. Please check your network settings.';
          } else {
            errorMessage = 'Registration failed: ${e.toString()}';
          }

          Utils.snakBar('Register Error', errorMessage);
          return;
        }

        // Wait before retry
        int waitTime = (2 * retryCount) + 1; // 3, 5, 7 seconds
        print('⏳ Waiting $waitTime seconds before retry...');
        Utils.snakBar(
          'Retrying',
          'Registration attempt failed. Retrying in $waitTime seconds...',
        );
        await Future.delayed(Duration(seconds: waitTime));
      }
    }
  }
//}
