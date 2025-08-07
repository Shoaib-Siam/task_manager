class Urls {
  static const String _baseurl = 'http://35.73.30.144:2005/api/v1';
  static const String registrationUrl = '$_baseurl/Registration';
  static const String loginUrl = '$_baseurl/Login';
  static const String createNewTaskUrl = '$_baseurl/CreateTask';
  static const String newTasksUrl = '$_baseurl/listTaskByStatus/New';
  static const String progressTasksUrl = '$_baseurl/listTaskByStatus/Progress';
  static const String completedTasksUrl = '$_baseurl/listTaskByStatus/Completed';
  static const String cancelledTasksUrl = '$_baseurl/listTaskByStatus/Canceled';
  static const String taskStatusCountUrl = '$_baseurl/taskStatusCount';

}
