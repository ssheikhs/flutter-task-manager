import 'package:flutter/material.dart';

import '../data/models/task_model.dart';
import '../data/models/task_status_count_model.dart';
import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/snackbar.dart';
import '../widget/task_card.dart';
import '../widget/task_count_by_status.dart';
import 'create_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  static const String _status = 'New';

  List<TaskStatusCountModel> taskCountList = [];
  List<TaskModel> taskList = [];
  bool _taskListInProgress = false;
  bool _taskCountInProgress = false;

  @override
  void initState() {
    super.initState();
    getAllTaskCount();
    getAllTask();
  }

  Future<void> getAllTaskCount() async {
    _taskCountInProgress = true;
    if (mounted) setState(() {});

    final response = await ApiCaller.getRequest(URL: TMUrls.taskCount);

    List<TaskStatusCountModel> temList = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        temList.add(TaskStatusCountModel.fromJson(jsonData));
      }
    } else if (mounted) {
      showSnackBarMessage(context, response.errorMessage ?? 'Failed to load task counts');
    }

    _taskCountInProgress = false;
    if (mounted) {
      setState(() {
        taskCountList = temList;
      });
    }
  }

  Future<void> getAllTask() async {
    _taskListInProgress = true;
    if (mounted) setState(() {});

    final response = await ApiCaller.getRequest(URL: TMUrls.AllTask(_status));

    List<TaskModel> temList = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        temList.add(TaskModel.fromJson(jsonData));
      }
    } else if (mounted) {
      showSnackBarMessage(context, response.errorMessage ?? 'Failed to load tasks');
    }

    _taskListInProgress = false;
    if (mounted) {
      setState(() {
        taskList = temList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: Visibility(
              visible: !_taskCountInProgress,
              replacement: const Center(child: CircularProgressIndicator()),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: taskCountList.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 100,
                    child: TaskCountByStatus(
                      title: taskCountList[index].sId.toString(),
                      count: taskCountList[index].sum ?? 0,
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 5),
              ),
            ),
          ),
          Expanded(
            child: Visibility(
              visible: !_taskListInProgress,
              replacement: const Center(child: CircularProgressIndicator()),
              child: ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: taskList[index],
                    onStatusUpdate: () {
                      getAllTask();
                      getAllTaskCount();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF21bf73),
        onPressed: _onTapAddButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onTapAddButton() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
    );
    if (result == true) {
      getAllTask();
      getAllTaskCount();
    }
  }
}
