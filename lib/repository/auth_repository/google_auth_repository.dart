import 'package:google_sign_in/google_sign_in.dart';
import '../../utils/utils.dart';

class GoogleAuthRepository {
  // static final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: ['email', 'profile'],
  // );

  // /// Sign in with Google - Returns user data for API authentication
  // static Future<GoogleSignInResult> signInWithGoogle() async {
  //   try {
  //     // Check if user is already signed in
  //     GoogleSignInAccount? currentUser = _googleSignIn.currentUser;

  //     if (currentUser == null) {
  //       // Trigger the authentication flow
  //       currentUser = await _googleSignIn.signIn();
  //     }

  //     if (currentUser == null) {
  //       // User canceled the sign-in
  //       return GoogleSignInResult(
  //         success: false,
  //         message: 'Sign-in was canceled',
  //         errorType: GoogleSignInErrorType.userCanceled,
  //       );
  //     }

  //     // Get authentication details from the request
  //     final GoogleSignInAuthentication googleAuth =
  //         await currentUser.authentication;

  //   //  / if (googleAuth.accessToken == null || googleAuth.idToken == null) {
  //   //     return GoogleSignInResult(
  //   //       success: false,
  //   //       message: 'Failed to get authentication tokens',
  //   //       errorType: GoogleSignInErrorType.authenticationFailed,
  //   //     );
  //   //   }

  //     // Return Google user data for API authentication
  //     return GoogleSignInResult(
  //       success: true,
  //       message: 'Google Sign-in successful',
  //       user: GoogleUserData(
  //         uid: currentUser.id,
  //         email: currentUser.email,
  //         displayName: currentUser.displayName ?? '',
  //         photoURL: currentUser.photoUrl ?? '',
  //         idToken: googleAuth.idToken ?? '',
  //         accessToken: googleAuth.accessToken ?? '',
  //       ),
  //     );

  //   } catch (error) {
  //     return GoogleSignInResult(
  //       success: false,
  //       message: 'An unexpected error occurred: ${error.toString()}',
  //       errorType: GoogleSignInErrorType.unknownError,
  //     );
  //   }
  // }

  /// Sign out from Google
  // static Future<bool> signOut() async {
  //   try {
  //     await _googleSignIn.signOut();
  //     return true;
  //   } catch (error) {
  //     print('Error signing out: $error');
  //     return false;
  //   }
  // }

  // /// Check if user is currently signed in
  // static Future<bool> isSignedIn() async {
  //   try {
  //     final GoogleSignInAccount? account = await _googleSignIn.isSignedIn()
  //         ? _googleSignIn.currentUser
  //         : null;

  //     return account != null;
  //   } catch (error) {
  //     return false;
  //   }
  // }

  // /// Get current user data
  // static Future<GoogleUserData?> getCurrentUser() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = _googleSignIn.currentUser;

  //     if (googleUser != null) {
  //       final GoogleSignInAuthentication googleAuth =
  //           await googleUser.authentication;

  //       return GoogleUserData(
  //         uid: googleUser.id,
  //         email: googleUser.email,
  //         displayName: googleUser.displayName ?? '',
  //         photoURL: googleUser.photoUrl ?? '',
  //         idToken: googleAuth.idToken ?? '',
  //         accessToken: googleAuth.accessToken ?? '',
  //       );
  //     }
  //     return null;
  //   } catch (error) {
  //     return null;
  //   }
  // }

  // /// Handle silent sign-in (auto sign-in)
  // static Future<GoogleSignInResult> signInSilently() async {
  //   try {
  //     final GoogleSignInAccount? account = await _googleSignIn.signInSilently();

  //     if (account != null) {
  //       final GoogleSignInAuthentication googleAuth =
  //           await account.authentication;

  //       if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //         return GoogleSignInResult(
  //           success: true,
  //           message: 'Silent sign-in successful',
  //           user: GoogleUserData(
  //             uid: account.id,
  //             email: account.email,
  //             displayName: account.displayName ?? '',
  //             photoURL: account.photoUrl ?? '',
  //             idToken: googleAuth.idToken ?? '',
  //             accessToken: googleAuth.accessToken ?? '',
  //           ),
  //         );
  //       }
  //     }

  //     return GoogleSignInResult(
  //       success: false,
  //       message: 'Silent sign-in failed',
  //       errorType: GoogleSignInErrorType.silentSignInFailed,
  //     );
  //   } catch (error) {
  //     return GoogleSignInResult(
  //       success: false,
  //       message: 'Silent sign-in error: ${error.toString()}',
  //       errorType: GoogleSignInErrorType.unknownError,
  //     );
  //   }
  // }

  /// Convert Firebase error codes to user-friendly messages
  static String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'invalid-credential':
        return 'The credential is invalid or has expired.';
      case 'operation-not-allowed':
        return 'Google sign-in is not enabled.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-verification-code':
        return 'Invalid verification code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

/// Result class for Google Sign-In operations
class GoogleSignInResult {
  final bool success;
  final String message;
  final GoogleUserData? user;
  final GoogleSignInErrorType? errorType;
  final String? errorCode;

  GoogleSignInResult({
    required this.success,
    required this.message,
    this.user,
    this.errorType,
    this.errorCode,
  });
}

/// User data class
class GoogleUserData {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final String idToken;
  final String accessToken;

  GoogleUserData({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.idToken,
    required this.accessToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'idToken': idToken,
      'accessToken': accessToken,
    };
  }
}

/// Error types for better error handling
enum GoogleSignInErrorType {
  userCanceled,
  authenticationFailed,
  firebaseError,
  silentSignInFailed,
  unknownError,
}
