import 'package:flutter/material.dart';

import 'home.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF21bf73),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
          errorBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: const Color(0xFF21bf73),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const Home(),
    );
  }
}
