import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/screen_bg.dart';
import '../widget/snackbar.dart';
import 'login_screen.dart';
import 'set_password_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  final String email;

  const PinVerificationScreen({super.key, required this.email});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBG(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(42),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 170),
                Text('PIN Verification', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'A 6 digit verification pin has been sent to your email address',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                PinCodeTextField(
                  length: 6,
                  appContext: context,
                  controller: _otpTEController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                    selectedColor: Colors.green,
                    inactiveColor: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: !_inProgress,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: _onTapVerify,
                    child: const Text('Verify'),
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
    );
  }

  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _onTapVerify() {
    if (_otpTEController.text.length == 6) {
      _verifyOtp();
    } else {
      showSnackBarMessage(context, 'Enter a 6 digit OTP');
    }
  }

  Future<void> _verifyOtp() async {
    _inProgress = true;
    setState(() {});

    final otp = _otpTEController.text.trim();
    final response = await ApiCaller.getRequest(
      URL: TMUrls.recoverVerifyOtp(widget.email, otp),
    );

    _inProgress = false;
    setState(() {});

    if (response.isSuccess) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPasswordScreen(email: widget.email, otp: otp),
          ),
        );
      }
    } else if (mounted) {
      showSnackBarMessage(context, response.errorMessage ?? 'OTP verification failed');
    }
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}
