import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<User?> signInWithGoogle() async {
    try {
      // First initialize (if needed). You might pass serverClientId for Android.
      await _googleSignIn.initialize(
        // Optionally you can supply `serverClientId` (your OAuth Web client ID)
        // serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
      );

      // Then call authenticate (not signIn)
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) {
        // User cancelled or something
        return null;
      }

      // Now get authentication tokens
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.idToken, // may be null depending on scopes / platform
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Google sign-in failed: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();  // in 7.2.0 there’s a new method to clear token :contentReference[oaicite:1]{index=1}
    await _auth.signOut();
  }


   Future<Map<String, dynamic>> sendToBackend({
    required String serviceProviderId,
    required String serviceProviderToken,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }

    // Get Firebase ID Token (short-lived, verifiable)
    final idToken = await user.getIdToken();

    final url = Uri.parse("https://your-backend.com/api/auth/google");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
      body: jsonEncode({
        "service_provider_id": serviceProviderId,
        "service_provider_token": serviceProviderToken,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Backend error: ${response.statusCode} ${response.body}");
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

















// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

//   Future<User?> signInWithGoogle() async {
//     final googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) return null;

//     final googleAuth = await googleUser.authentication;

//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     final userCredential = await _auth.signInWithCredential(credential);
//     return userCredential.user;
//   }

//   Future<void> sendToBackend({
//     required String serviceId,
//     required String serviceProvider,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception("Not signed in");
//     }
//     final idToken = await user.getIdToken();

//     final url = Uri.parse("https://your-laravel-backend.com/api/auth/google");
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $idToken",
//       },
//       body: jsonEncode({
//         "service_id": serviceId,
//         "service_provider": serviceProvider,
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception("Backend error: ${response.statusCode} ${response.body}");
//     }

//     // Optionally process the response
//     final respData = jsonDecode(response.body);
//     print("Backend response: $respData");
//   }
// }
