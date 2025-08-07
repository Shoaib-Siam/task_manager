import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';

import '../../data/models/task_model.dart';
import '../../data/models/task_status_count_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_summary_card.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _taskStatusCountInProgress = false;
  bool _newTasksInProgress = false;
  List<TaskModel> _newTaskList = [];
  List<TaskStatusCountModel> _taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTaskStatusCountList();
      _getNewTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: Visibility(
                visible: _taskStatusCountInProgress == false,
                replacement: CenteredCircularProgressIndicator(),
                child: ListView.separated(
                  itemCount: _taskStatusCountList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCountSummaryCard(
                      title: _taskStatusCountList[index].id,
                      count: _taskStatusCountList[index].count,
                    );
                  },
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 8),
                ),
              ),
            ),

            Expanded(
              child: Visibility(
                visible: _newTasksInProgress == false,
                replacement: CenteredCircularProgressIndicator(),
                child:
                    _newTaskList.isEmpty
                        ? Center(child: Text('No new tasks found.'))
                        : ListView.builder(
                          itemCount: _newTaskList.length,
                          itemBuilder: (context, index) {
                            return TaskCard(
                              taskType: TaskType.tNew,
                              taskModel: _newTaskList[index],
                              onStatusUpdate: () {
                                _getNewTaskList();
                                _getTaskStatusCountList();
                              },
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _getTaskStatusCountList() async {
    _taskStatusCountInProgress = true;
    setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.taskStatusCountUrl,
    );

    if (response.success) {
      List<TaskStatusCountModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskStatusCountModel.fromJson(jsonData));
      }
      _taskStatusCountList = taskList;
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
    _taskStatusCountInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getNewTaskList() async {
    _newTasksInProgress = true;
    setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.newTasksUrl,
    );

    if (response.success) {
      List<TaskModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = taskList;
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
    _newTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _onTapAddNewTaskButton() {
    Navigator.pushNamed(context, AddNewTaskScreen.routeName);
  }
}
