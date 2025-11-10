import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gig/repository/auth_repository/social_login_repository.dart';
import 'package:gig/view_models/controller/otp/resend_otp_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/auth/user_model.dart';
import '../../../repository/auth_repository/register_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterVewModel extends GetxController {
  final _api = RegisterRepository();
  UserPreference userPreference = UserPreference();
  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final phoneNumberController = TextEditingController().obs;
  RxBool googleLoading = false.obs;

  RxBool loading = false.obs;
  final _socialApi = SocialLoginRepository();
  Future<String?> _getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // On Android 13+ and iOS: ask user for notification permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔥 FCM Permission Status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      // Extra fallback using permission_handler (some OEMs block by default)
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }

      if (await Permission.notification.isDenied) {
        print('🚫 Notification permission denied');
        return null;
      }
    }

    // ✅ Always try to get the token if not denied
    String? token = await messaging.getToken();
    print("✅ FCM Token: $token");
    return token;
  }

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
          await storage.write(key: 'user_email', value: value['data']['email']);

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
          await prefs.setString('otp_email', emailController.value.text.trim());

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

  void registerApiWithGoogle({
    required String providerId,
    required String email,
    required String displayName,
    required String photoUrl,
  }) async {
    try {
      loading.value = true;

      String token = await _getToken() ?? '';
      Map data = {
        //'password': passwordController.value.text,
        'fcm_token': token,
        'service_provider': 'google',
        'service_provider_id': providerId,
        'email': email,
        'name': displayName,
        'profile_image': photoUrl,
      };

      // Await the API call only once
      final value = await _socialApi.SocialLoginApi(data);

      loading.value = false;

      if (value['status'] == true) {
        Utils.snakBar('Login', value['message']);

        // Store user data
        final storage = FlutterSecureStorage();
        await storage.write(key: 'auth_token', value: value['token']);
        await storage.write(key: 'user_name', value: value['user']['name']);
        await storage.write(key: 'user_email', value: value['user']['email']);
        await storage.write(
          key: 'user_id',
          value: value['user']['id'].toString(),
        );
        await storage.write(
          key: 'user_phone',
          value: value['user']['phone_number'],
        );

        // Navigate to home
        Get.offAllNamed(RoutesName.home);
      } else {
        // Handle backend validation errors
        String errorMsg = value['message'] ?? 'Something went wrong';

        if (value['errors'] != null && value['errors'] is Map) {
          Map<String, dynamic> errors = value['errors'];
          String detailedErrorMsg = errors.values
              .expand((list) => list)
              .join('\n');

          Utils.snakBar(
            'Login',
            detailedErrorMsg.isNotEmpty ? detailedErrorMsg : errorMsg,
          );
        } else {
          Utils.snakBar('Login', errorMsg);
        }
      }
    } catch (error) {
      loading.value = false;
      print('Login API error: $error');
      Utils.snakBar('Error', error.toString());
    }
  }
  // /// Sign in with Google
  // Future<User?> signInWithGoogle() async {
  //   try {
  //     // 1. Trigger Google Sign-In flow
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       // User canceled the sign-in
  //       return null;
  //     }

  //     // 2. Get Google Auth tokens
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // 3. Create Firebase credential
  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       idToken: googleAuth.idToken,
  //       accessToken: googleAuth.accessToken,
  //     );

  //     // 4. Sign in to Firebase
  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);

  //     // 5. Return Firebase user
  //     return userCredential.user;
  //   } catch (e, stackTrace) {
  //     print("❌ Google Sign-In failed: $e");
  //     print(stackTrace); // helps in debugging
  //     return null;
  //   }
}

//}
