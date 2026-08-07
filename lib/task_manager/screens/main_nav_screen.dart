import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import 'cancel_task_screen.dart';
import 'completed_task_screen.dart';
import 'login_screen.dart';
import 'new_task_screen.dart';
import 'profile_screen.dart';
import 'progress_task_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF21bf73),
        titleSpacing: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: _onTapProfile,
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AuthController.userModel?.fullName ?? '',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    AuthController.userModel?.email ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _onTapLogout,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF21bf73),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'New'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time_rounded), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outlined), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.cancel_outlined), label: 'Cancelled'),
        ],
      ),
    );
  }

  void _onTapProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  Future<void> _onTapLogout() async {
    await AuthController.clearUserData();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
