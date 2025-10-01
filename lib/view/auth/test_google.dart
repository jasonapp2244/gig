import 'package:flutter/material.dart';
import 'package:gig/view/auth/auth_servies.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  String _message = "";

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _loading = true;
      _message = "";
    });

    final result = await GoogleAuthRepository.signInWithGoogle();

    setState(() {
      _loading = false;
      if (result.success) {
            print(result.user?.email);

 print(result.user?.displayName);
 print(result.user?.uid);
 print(result.user?.idToken.substring(0, 20));

        _message = "✅ Login successful!\n\n"
            "Email: ${result.user?.email}\n"
            "Name: ${result.user?.displayName}\n"
            "UID: ${result.user?.uid}\n"
            "ID Token (short): ${result.user?.idToken.substring(0, 20)}...";
      } else {
        _message = "❌ Login failed: ${result.message}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Login Test")),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text("Sign in with Google"),
                    onPressed: _handleGoogleLogin,
                  ),
                  const SizedBox(height: 20),
                  if (_message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _message,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
