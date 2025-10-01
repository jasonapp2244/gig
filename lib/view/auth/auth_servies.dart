import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/utils.dart';
import 'package:gig/utils/utils.dart';
import 'package:gig/view_models/controller/auth/login_view_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthRepository {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final LoginVewModel loginVM = Get.put(LoginVewModel());
  static GoogleSignInAccount? _currentUser;

  // Initialize Google Sign-In and set up authentication event listener
  static Future<void> initialize() async {
    // Listen to authentication events
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;
    });

    // Attempt to sign in silently to restore previous session
    if (_currentUser != null)
      _currentUser = await _googleSignIn.signInSilently();
  }

  // Sign in with Google - Returns user data for API authentication
  static Future<GoogleSignInResult> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        // User canceled the sign-in
        return GoogleSignInResult(
          success: false,
          message: 'Sign-in was canceled',
          errorType: GoogleSignInErrorType.userCanceled,
        );
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      // Check if we have the required tokens
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        return GoogleSignInResult(
          success: false,
          message: 'Failed to get authentication tokens',
          errorType: GoogleSignInErrorType.authenticationFailed,
        );
      }

      Utils.writeSecureStorage('provider_token', idToken.toString());
      Utils.writeSecureStorage('email',account.email);
      

      return GoogleSignInResult(
        success: true,
        message: 'Google Sign-in successful',
        user: GoogleUserData(
          uid: account.id,
          email: account.email,
          displayName: account.displayName ?? '',
          photoURL: account.photoUrl ?? '',
          idToken: idToken,
          accessToken: accessToken,
        ),
      );
    } catch (error) {
      return GoogleSignInResult(
        success: false,
        message: 'An unexpected error occurred: ${error.toString()}',
        errorType: GoogleSignInErrorType.unknownError,
      );
    }
  }

  /// Sign out from Google
  static Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      return true;
    } catch (error) {
      print('Error signing out: $error');
      return false;
    }
  }

  /// Disconnect from Google (more complete sign out)
  static Future<bool> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      _currentUser = null;
      return true;
    } catch (error) {
      print('Error disconnecting: $error');
      return false;
    }
  }

  /// Check if user is currently signed in
  static Future<bool> isSignedIn() async {
    try {
      return _currentUser != null;
    } catch (error) {
      return false;
    }
  }

  /// Get current user data
  static Future<GoogleUserData?> getCurrentUser() async {
    try {
      final GoogleSignInAccount? googleUser = _currentUser;

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final String? accessToken = googleAuth.accessToken;
        final String? idToken = googleAuth.idToken;

        return GoogleUserData(
          uid: googleUser.id,
          email: googleUser.email,
          displayName: googleUser.displayName ?? '',
          photoURL: googleUser.photoUrl ?? '',
          idToken: idToken ?? '',
          accessToken: accessToken ?? '',
        );
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  /// Handle silent sign-in (auto sign-in)
  static Future<GoogleSignInResult> signInSilently() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signInSilently();

      if (account != null) {
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;

        final String? accessToken = googleAuth.accessToken;
        final String? idToken = googleAuth.idToken;

        if (accessToken != null && idToken != null) {
          return GoogleSignInResult(
            success: true,
            message: 'Silent sign-in successful',
            user: GoogleUserData(
              uid: account.id,
              email: account.email,
              displayName: account.displayName ?? '',
              photoURL: account.photoUrl ?? '',
              idToken: idToken,
              accessToken: accessToken,
            ),
          );
        }
      }

      return GoogleSignInResult(
        success: false,
        message: 'Silent sign-in failed',
        errorType: GoogleSignInErrorType.silentSignInFailed,
      );
    } catch (error) {
      return GoogleSignInResult(
        success: false,
        message: 'Silent sign-in error: ${error.toString()}',
        errorType: GoogleSignInErrorType.unknownError,
      );
    }
  }

  /// Get authorization headers for API calls
  static Future<Map<String, String>?> getAuthorizationHeaders() async {
    try {
      final GoogleSignInAccount? user = _currentUser;
      if (user != null) {
        final GoogleSignInAuthentication auth = await user.authentication;
        return {
          'Authorization': 'Bearer ${auth.accessToken}',
          'Content-Type': 'application/json',
        };
      }
      return null;
    } catch (error) {
      print('Error getting authorization headers: $error');
      return null;
    }
  }

  /// Get the current signed-in user (if any)
  static GoogleSignInAccount? get currentUser => _currentUser;
}

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
