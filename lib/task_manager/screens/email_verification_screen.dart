import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/screen_bg.dart';
import '../widget/snackbar.dart';
import 'login_screen.dart';
import 'pin_verification_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                  Text('Your Email Address', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'A 6 digit verification pin will be sent to your email address',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: !_inProgress,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                      onPressed: _onTapConfirm,
                      child: const Icon(Icons.arrow_circle_right_outlined),
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
      _verifyEmail();
    }
  }

  Future<void> _verifyEmail() async {
    _inProgress = true;
    setState(() {});

    final email = _emailTEController.text.trim();
    final response = await ApiCaller.getRequest(URL: TMUrls.recoverVerifyEmail(email));

    _inProgress = false;
    setState(() {});

    if (response.isSuccess) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PinVerificationScreen(email: email)),
        );
      }
    } else if (mounted) {
      showSnackBarMessage(context, response.errorMessage ?? 'Verification failed');
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
