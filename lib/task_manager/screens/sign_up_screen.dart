import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/screen_bg.dart';
import '../widget/snackbar.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _signUpInProgress = false;

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
                  Text('Join With Us', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(hintText: 'First Name'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Enter your first name' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Enter your last name' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _mobileTEController,
                    decoration: const InputDecoration(hintText: 'Mobile'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Enter your mobile number' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (v) => ((v?.length ?? 0) <= 6) ? 'Enter a password longer than 6 characters' : null,
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: !_signUpInProgress,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                      onPressed: _onTapSignUpButton,
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
                            recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
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

  void _onTapSignInButton() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _onTapSignUpButton() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    _signUpInProgress = true;
    setState(() {});

    final response = await ApiCaller.postRequest(
      URL: TMUrls.SignupURL,
      body: {
        'email': _emailTEController.text.trim(),
        'firstName': _firstNameTEController.text.trim(),
        'lastName': _lastNameTEController.text.trim(),
        'mobile': _mobileTEController.text.trim(),
        'password': _passwordTEController.text,
      },
    );

    _signUpInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      _clearFields();
      if (mounted) {
        showSnackBarMessage(context, 'Registration successful. Please login.');
      }
    } else if (mounted) {
      showSnackBarMessage(context, response.errorMessage ?? 'Registration failed');
    }
  }

  void _clearFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
