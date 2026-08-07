import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../data/models/user_model.dart';
import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/screen_bg.dart';
import '../widget/snackbar.dart';
import 'main_nav_screen.dart';
import 'sign_up_screen.dart';
import 'email_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loginInProgress = false;

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
                  Text('Get Started With', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a valid password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: !_loginInProgress,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                      onPressed: _onTapLoginButton,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: _onTapForgotPassword,
                          child: const Text('Forgot Password?', style: TextStyle(color: Colors.grey)),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Don't have account? ",
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: const TextStyle(
                                  color: Color(0xFF21bf73),
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = _onTapSignUp,
                              ),
                            ],
                          ),
                        ),
                      ],
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

  void _onTapSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void _onTapForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmailVerificationScreen()),
    );
  }

  void _onTapLoginButton() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  Future<void> _login() async {
    _loginInProgress = true;
    setState(() {});

    final response = await ApiCaller.postRequest(
      URL: TMUrls.LoginURL,
      body: {
        'email': _emailTEController.text.trim(),
        'password': _passwordTEController.text,
      },
    );

    if (response.isSuccess) {
      final userModel = UserModel.fromJson(response.responseData['data']);
      final token = response.responseData['token'];
      await AuthController.saveUserData(userModel, token);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainNavScreen()),
          (route) => false,
        );
      }
    } else {
      _loginInProgress = false;
      setState(() {});
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage ?? 'Login failed');
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
