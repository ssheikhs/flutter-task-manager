import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/screen_bg.dart';
import '../widget/snackbar.dart';
import 'login_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const SetPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBG(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(42),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 170),
                  Text('Set Password', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Minimum length password 6 characters with letter and number combination',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (v) => ((v?.length ?? 0) < 6) ? 'Password must be at least 6 characters' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    controller: _confirmPasswordTEController,
                    decoration: const InputDecoration(hintText: 'Confirm Password'),
                    validator: (v) => (v != _passwordTEController.text) ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: !_inProgress,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                      onPressed: _onTapConfirm,
                      child: const Text('Confirm'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Have account? ',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: const TextStyle(color: Color(0xFF21bf73), fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()..onTap = _onTapSignIn,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _onTapConfirm() {
    if (_formKey.currentState!.validate()) {
      _resetPassword();
    }
  }

  Future<void> _resetPassword() async {
    _inProgress = true;
    setState(() {});

    final response = await ApiCaller.postRequest(
      URL: TMUrls.recoverResetPassword,
      body: {
        'email': widget.email,
        'OTP': widget.otp,
        'password': _passwordTEController.text.trim(),
      },
    );

    _inProgress = false;
    setState(() {});

    if (response.isSuccess) {
      if (mounted) {
        showSnackBarMessage(context, 'Password reset successful. Please sign in.');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } else if (mounted) {
      showSnackBarMessage(context, response.errorMessage ?? 'Password reset failed');
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
