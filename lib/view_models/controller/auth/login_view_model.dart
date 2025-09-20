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

  RxBool loading = false.obs;

  // void loginApi() async {
  //   loading.value = true;
  //   Map data = {
  //     'email': emailController.value.text,
  //     'password': passwordController.value.text,
  //   };

  //   final value = await _api.loginApi(data);

  //   loading.value = false;

  //   _api
  //       .loginApi(data)
  //       .then((value) async {
  //         loading.value = false;

  //         if (value['status'] == true) {
  //           Utils.snakBar('Login', value['message']);

  //           // Store auth token and user data only on successful login
  //           final _storage = FlutterSecureStorage();
  //           await _storage.write(key: 'auth_token', value: value['token']);
  //           await _storage.write(
  //             key: 'user_name',
  //             value: value['user']['name'],
  //           );
  //           await _storage.write(
  //             key: 'user_email',
  //             value: value['user']['email'],
  //           );
  //           await _storage.write(
  //             key: 'user_id',
  //             value: value['user']['id'].toString(),
  //           );
  //           await _storage.write(
  //             key: 'user_phone',
  //             value: value['user']['phone_number'],
  //           );

  //           // Navigate to home only on successful login
  //           Get.toNamed(RoutesName.home);
  //         } else {
  //           String errorMsg = value['message'] ?? 'Something went wrong';

  //           // Check for nested validation errors first
  //           if (value['errors'] != null && value['errors'] is Map) {
  //             Map<String, dynamic> errors = value['errors'];
  //             String detailedErrorMsg = '';

  //             // Combine all validation errors
  //             errors.forEach((field, errorList) {
  //               if (errorList is List) {
  //                 for (String error in errorList) {
  //                   if (detailedErrorMsg.isNotEmpty) {
  //                     detailedErrorMsg += '\n';
  //                   }
  //                   detailedErrorMsg += error;
  //                 }
  //               }
  //             });

  //             // Show the detailed validation errors from backend
  //             Utils.snakBar(
  //               'Login',
  //               detailedErrorMsg.isNotEmpty ? detailedErrorMsg : errorMsg,
  //             );
  //           } else {
  //             // Show the general backend error message
  //             Utils.snakBar('Login', errorMsg);
  //           }
  //         }
  //       })
  //       .onError((error, stackTrace) {
  //         loading.value = false;
  //         print('Login API error: ${error.toString()}');
  //         Utils.snakBar('Error', error.toString());
  //       });
  // }
  //   Future<Map<String, dynamic>?> signInWithGoogle() async {
  //   try {
  //     // 1. Trigger Google Sign-In
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       print("🚫 Google Sign-In canceled by user");
  //       return null;
  //     }

  //     // 2. Get authentication details
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // 3. Create Firebase credential
  //     final OAuth credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // 4. Sign in to Firebase
  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);

  //     final User? user = userCredential.user;

  //     if (user == null) return null;

  //     // 🔥 Extract provider info
  //     final providerData = user.providerData.first;
  //     final String providerId = providerData.providerId; // "google.com"
  //     final String serviceId = providerData.uid;         // Google account ID

  //     print("✅ Google Sign-In successful: ${user.displayName}");
  //     print("📧 Email: ${user.email}");
  //     print("🆔 Firebase UID: ${user.uid}");
  //     print("🌐 Provider: $providerId");
  //     print("🆔 Service ID: $serviceId");

  //     // Return a structured object you can send to your backend
  //     return {
  //       "firebase_uid": user.uid,
  //       "email": user.email,
  //       "name": user.displayName,
  //       "photo": user.photoURL,
  //       "provider_id": providerId, // "google.com"
  //       "service_id": serviceId,   // Google account ID
  //     };
  //   } catch (e, stack) {
  //     print("❌ Google Sign-In failed: $e");
  //     print(stack);
  //     return null;
  //   }
  // }

  // /// Sign out from Google + Firebase
  // Future<void> signOut() async {
  //   await _googleSignIn.signOut();
  //   await _auth.signOut();
  //   print("👋 Signed out from Google and Firebase");
  // }

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

  void loginApi() async {
    try {
      loading.value = true;

      String token = await _getToken() ?? '';
      Map data = {
        'email': emailController.value.text,
        'password': passwordController.value.text,
        'fcm_token': token,
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
    } catch (error, stackTrace) {
      loading.value = false;
      print('Login API error: $error');
      Utils.snakBar('Error', error.toString());
    }
  }
}
