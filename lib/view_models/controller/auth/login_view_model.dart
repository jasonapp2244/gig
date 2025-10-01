import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gig/view/auth/auth_servies.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../repository/auth_repository/login_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
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
  RxBool googleLoading = false.obs;

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

  // /// Enhanced Google Sign-In with API integration
  // Future<void> signInWithGoogle() async {
  //   try {
  //     googleLoading.value = true;

  //     print('🔄 Starting Google Sign-In...');

  //     // Step 1: Get Google Sign-In result
  //     final result = await GoogleAuthRepository.signInWithGoogle();

  //     if (result.success && result.user != null) {
  //       print('✅ Google Sign-In successful, now calling login API...');

  //       // Step 2: Call your existing login API with Google data
  //       await _loginWithGoogleData(result.user!);
  //     } else {
  //       // Handle different error types with appropriate messages
  //       String userMessage = _getGoogleSignInUserMessage(result);
  //       Utils.snakBar('Sign-In Failed', userMessage);

  //       print('❌ Google Sign-In failed: ${result.message}');
  //     }
  //   } catch (error) {
  //     Utils.snakBar('Error', 'An unexpected error occurred during sign-in');
  //     print('❌ Unexpected Google Sign-In error: $error');
  //   } finally {
  //     googleLoading.value = false;
  //   }
  // }

  // /// Silent Google Sign-In for auto-login
  // Future<void> attemptSilentGoogleSignIn() async {
  //   try {
  //     print('🔄 Attempting silent Google Sign-In...');

  //     final result = await GoogleAuthRepository.signInSilently();

  //     if (result.success && result.user != null) {
  //       // Use the API for silent sign-in too
  //       await _loginWithGoogleData(result.user!);
  //       print('✅ Silent Google Sign-In successful');
  //     } else {
  //       print('ℹ️ Silent Google Sign-In failed: ${result.message}');
  //     }
  //   } catch (error) {
  //     print('❌ Silent Google Sign-In error: $error');
  //   }
  // }

  /// Get user-friendly message for Google Sign-In errors
  String _getGoogleSignInUserMessage(GoogleSignInResult result) {
    switch (result.errorType) {
      case GoogleSignInErrorType.userCanceled:
        return 'Sign-in was canceled. Please try again.';
      case GoogleSignInErrorType.authenticationFailed:
        return 'Authentication failed. Please check your Google account.';
      case GoogleSignInErrorType.firebaseError:
        return 'Connection error. Please check your internet and try again.';
      case GoogleSignInErrorType.silentSignInFailed:
        return 'Auto sign-in failed. Please sign in manually.';
      case GoogleSignInErrorType.unknownError:
      default:
        return result.message.isNotEmpty
            ? result.message
            : 'Something went wrong. Please try again.';
    }
  }

  // /// Sign out from Google
  // Future<void> signOutFromGoogle() async {
  //   try {
  //     final success = await GoogleAuthRepository.signOut();
  //     if (success) {
  //       // Clear stored data
  //       final storage = FlutterSecureStorage();
  //       await storage.deleteAll();

  //       Utils.snakBar('Success', 'Signed out successfully');
  //       Get.offAllNamed(RoutesName.loginScreen);
  //       print('✅ Google Sign-Out successful');
  //     } else {
  //       Utils.snakBar('Error', 'Failed to sign out');
  //       print('❌ Google Sign-Out failed');
  //     }
  //   } catch (error) {
  //     Utils.snakBar('Error', 'An error occurred during sign out');
  //     print('❌ Google Sign-Out error: $error');
  //   }
  // }

  // /// Check if user is signed in with Google
  // Future<bool> isGoogleSignedIn() async {
  //   try {
  //     return await GoogleAuthRepository.isSignedIn();
  //   } catch (error) {
  //     print('❌ Error checking Google sign-in status: $error');
  //     return false;
  //   }
  // }

  void loginApiWithGoogle({required String providerId, String? email}) async {
    try {
      loading.value = true;

      String token = await _getToken() ?? '';
      Map data = {
        'email': email,
        //'password': passwordController.value.text,
        'fcm_token': token,
        'service_provider': 'google',
        'service_provider_id': providerId,
      };

      // Await the API call only once
      final value = await _api.loginApi(data);

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

  void loginApi() async {
    try {
      loading.value = true;

      String token = await _getToken() ?? '';
      Map data = {
        'email': emailController.value.text,
        'password': passwordController.value.text,
        'fcm_token': token,
      };
      print("...$token");

      // Await the API call only once
      final value = await _api.loginApi(data);

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
}
