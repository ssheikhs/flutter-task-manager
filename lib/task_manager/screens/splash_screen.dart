import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../utils/asset_path.dart';
import 'login_screen.dart';
import 'main_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    bool isLogin = await AuthController.isUserLogin();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isLogin ? const MainNavScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(AssetPath.logo, width: 300, height: 300)),
    );
  }
}
