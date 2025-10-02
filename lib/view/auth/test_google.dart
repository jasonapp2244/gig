import 'package:flutter/material.dart';
import 'package:gig/view/auth/auth_servies.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  bool _loading = false;
  String _message = "";

  void _handleGoogleLogin() async {
    setState(() {
      _loading = true;
      _message = "";
    });

    final user = await _authService.signInWithGoogle();
    if (user == null) {
      setState(() {
        _loading = false;
        _message = "Google sign-in canceled or failed";
      });
      return;
    }

    try {
      final backendResult = await _authService.sendToBackend(
        serviceProviderId: "xyz123",
        serviceProviderToken: "some_token_value",
      );

      setState(() {
        _loading = false;
        _message = "Backend success: ${backendResult.toString()}";
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _message = "Backend error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Login")),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text("Sign in with Google"),
                    onPressed: _handleGoogleLogin,
                  ),
                  if (_message.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Text(_message),
                  ],
                ],
              ),
      ),
    );
  }
}
