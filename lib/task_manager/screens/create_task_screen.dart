import 'package:flutter/material.dart';

import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/screen_bg.dart';
import '../widget/snackbar.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  bool _createInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF21bf73)),
      body: ScreenBG(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text('Add New Task', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleTEController,
                  decoration: const InputDecoration(hintText: 'Subject'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a subject' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionTEController,
                  maxLines: 8,
                  decoration: const InputDecoration(hintText: 'Description'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a description' : null,
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: !_createInProgress,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: _onTapSubmit,
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

  void _onTapSubmit() {
    if (_formKey.currentState!.validate()) {
      _createTask();
    }
  }

  Future<void> _createTask() async {
    _createInProgress = true;
    setState(() {});

    final response = await ApiCaller.postRequest(
      URL: TMUrls.createTask,
      body: {
        'title': _titleTEController.text.trim(),
        'description': _descriptionTEController.text.trim(),
        'status': 'New',
      },
    );

    _createInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      if (mounted) {
        showSnackBarMessage(context, 'Task added successfully');
        Navigator.pop(context, true);
      }
    } else if (mounted) {
      showSnackBarMessage(context, response.errorMessage ?? 'Failed to add task');
    }
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
