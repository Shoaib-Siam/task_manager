import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() =>
      _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  bool _cancelledTasksInProgress = false;
  List<TaskModel> _cancelledTaskList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCancelledTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: _cancelledTasksInProgress == false,
        replacement: CenteredCircularProgressIndicator(),
        child:
            _cancelledTaskList.isEmpty
                ? const Center(child: Text('No cancelled tasks found.'))
                : ListView.builder(
                  itemCount: _cancelledTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskType: TaskType.cancelled,
                      taskModel: _cancelledTaskList[index],
                      onStatusUpdate: () {
                        _getCancelledTaskList();
                      },
                    );
                  },
                ),
      ),
    );
  }

  Future<void> _getCancelledTaskList() async {
    _cancelledTasksInProgress = true;
    setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.cancelledTasksUrl,
    );

    if (response.success) {
      List<TaskModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = taskList;
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
    _cancelledTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
