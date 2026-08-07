import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/screen_bg.dart';
import '../widget/snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  bool _updateInProgress = false;

  @override
  void initState() {
    super.initState();
    final user = AuthController.userModel;
    _emailTEController.text = user?.email ?? '';
    _firstNameTEController.text = user?.firstName ?? '';
    _lastNameTEController.text = user?.lastName ?? '';
    _mobileTEController.text = user?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF21bf73),
        title: const Text('Profile'),
      ),
      body: ScreenBG(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF21bf73),
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailTEController,
                  enabled: false,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _firstNameTEController,
                  decoration: const InputDecoration(hintText: 'First Name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your first name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: const InputDecoration(hintText: 'Last Name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your last name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _mobileTEController,
                  decoration: const InputDecoration(hintText: 'Mobile'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your mobile number' : null,
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: !_updateInProgress,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: _onTapSave,
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSave() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    _updateInProgress = true;
    setState(() {});

    final response = await ApiCaller.postRequest(
      URL: TMUrls.updateProfile,
      body: {
        'email': _emailTEController.text.trim(),
        'firstName': _firstNameTEController.text.trim(),
        'lastName': _lastNameTEController.text.trim(),
        'mobile': _mobileTEController.text.trim(),
      },
    );

    _updateInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      final user = AuthController.userModel;
      if (user != null) {
        user.firstName = _firstNameTEController.text.trim();
        user.lastName = _lastNameTEController.text.trim();
        user.mobile = _mobileTEController.text.trim();
      }
      if (mounted) {
        showSnackBarMessage(context, 'Profile updated successfully');
      }
    } else if (mounted) {
      showSnackBarMessage(context, response.errorMessage ?? 'Failed to update profile');
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    super.dispose();
  }
}
