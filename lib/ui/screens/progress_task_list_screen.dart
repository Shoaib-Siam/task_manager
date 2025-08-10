import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  bool _progressTasksInProgress = false;
  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getProgressTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: _progressTasksInProgress == false,
        replacement: CenteredCircularProgressIndicator(),
        child:
            _progressTaskList.isEmpty
                ? const Center(child: Text('No progress tasks found.'))
                : ListView.builder(
                  itemCount: _progressTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskType: TaskType.progress,
                      taskModel: _progressTaskList[index],
                      onStatusUpdate: () {
                        _getProgressTaskList();
                      },
                      onDelete: () {
                        setState(() {
                          _progressTaskList.removeAt(index);
                        });
                      },
                    );
                  },
                ),
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    _progressTasksInProgress = true;
    setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.progressTasksUrl,
    );

    if (response.success) {
      List<TaskModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = taskList;
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Something went wrong. Please try again.',
        );
      }
    }
    _progressTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
