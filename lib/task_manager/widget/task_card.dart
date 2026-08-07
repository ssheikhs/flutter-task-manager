import 'package:flutter/material.dart';

import '../data/models/task_model.dart';
import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import 'snackbar.dart';

class TaskCard extends StatefulWidget {
  final TaskModel taskModel;
  final VoidCallback onStatusUpdate;

  const TaskCard({super.key, required this.taskModel, required this.onStatusUpdate});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _updateInProgress = false;
  bool _deleteInProgress = false;

  static const List<String> _statuses = ['New', 'In Progress', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
            ),
            Text(
              widget.taskModel.description,
              style: const TextStyle(color: Colors.black45),
            ),
            Text(
              'Date: ${widget.taskModel.createdDate}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(
                    widget.taskModel.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  backgroundColor: _getChipColor(),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _updateInProgress ? null : _showChangeStatusDialog,
                  icon: const Icon(Icons.edit_calendar, color: Colors.green),
                ),
                IconButton(
                  onPressed: _deleteInProgress ? null : _showDeleteConfirmationDialog,
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getChipColor() {
    switch (widget.taskModel.status) {
      case 'In Progress':
        return Colors.purpleAccent;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      case 'New':
      default:
        return Colors.lightBlueAccent;
    }
  }

  void _showChangeStatusDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change Status'),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _statuses.map((status) {
              final isActive = widget.taskModel.status == status;
              return Card(
                elevation: 0,
                color: isActive ? Colors.green.shade50 : null,
                child: ListTile(
                  title: Text(status),
                  trailing: isActive ? const Icon(Icons.check, color: Colors.green) : null,
                  onTap: () {
                    Navigator.pop(dialogContext);
                    if (!isActive) {
                      _changeStatus(status);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _deleteTask();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changeStatus(String status) async {
    _updateInProgress = true;
    if (mounted) setState(() {});

    final response = await ApiCaller.getRequest(
      URL: TMUrls.updateTask(widget.taskModel.id, status),
    );

    _updateInProgress = false;
    if (mounted) setState(() {});

    if (response.isSuccess) {
      widget.onStatusUpdate();
    } else if (mounted) {
      showSnackBarMessage(context, response.errorMessage ?? 'Failed to update status');
    }
  }

  Future<void> _deleteTask() async {
    _deleteInProgress = true;
    if (mounted) setState(() {});

    final response = await ApiCaller.getRequest(URL: TMUrls.deleteTask(widget.taskModel.id));

    _deleteInProgress = false;
    if (mounted) setState(() {});

    if (response.isSuccess) {
      widget.onStatusUpdate();
    } else if (mounted) {
      showSnackBarMessage(context, response.errorMessage ?? 'Failed to delete task');
    }
  }
}
