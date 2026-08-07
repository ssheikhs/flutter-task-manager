import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

/// Entry widget used as `MaterialApp.home`. Every navigation after this
/// point is a direct `Navigator.push`/`pushReplacement` with a
/// `MaterialPageRoute` — this project doesn't use named routes.
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
