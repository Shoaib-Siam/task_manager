import 'package:get/get.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';

class NewTaskListController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<TaskModel> _newTaskList = [];
  List<TaskModel> get newTaskList => _newTaskList;

  Future<bool> getNewTaskList() async {
    bool isSuccessful = false;
    _inProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.newTasksUrl,
    );

    if (response.success) {
      List<TaskModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = taskList;
      _errorMessage = null;
      isSuccessful = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccessful;
  }
}
