import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import 'centered_circular_progress_indicator.dart';

enum TaskType { tNew, progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskType,
    required this.taskModel,
    required this.onStatusUpdate,
    required this.onDelete,
  });

  final TaskType taskType;
  final TaskModel taskModel;
  final VoidCallback onStatusUpdate;
  final VoidCallback onDelete;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _updateTaskStatusInProgress = false;
  bool _deleteTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              widget.taskModel.description,
              style: TextStyle(color: Colors.grey),
            ),
            Text('Date: ${widget.taskModel.createdDate}'),
            SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(
                    _getTaskTypeName(),
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getTaskChipColor(),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                ),
                Spacer(),
                Visibility(
                  visible: _updateTaskStatusInProgress == false,
                  replacement: CenteredCircularProgressIndicator(),
                  child: IconButton(
                    onPressed: () {
                      _showEditTaskDialog();
                    },
                    icon: Icon(Icons.edit),
                  ),
                ),
                Visibility(
                  visible: _deleteTaskInProgress == false,
                  replacement: CenteredCircularProgressIndicator(),
                  child: IconButton(
                    onPressed: () {
                      _onDeletePressed();
                    },
                    icon: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTaskChipColor() {
    switch (widget.taskType) {
      case TaskType.tNew:
        return Colors.blue;
      case TaskType.progress:
        return Colors.purple;
      case TaskType.completed:
        return Colors.green;
      case TaskType.cancelled:
        return Colors.red;
    }
  }

  String _getTaskTypeName() {
    switch (widget.taskType) {
      case TaskType.tNew:
        return 'New';
      case TaskType.progress:
        return 'Progress';
      case TaskType.completed:
        return 'Completed';
      case TaskType.cancelled:
        return 'Canceled';
    }
  }

  void _showEditTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Task Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('New'),
                trailing: _getTaskStatusTrailing(TaskType.tNew),
                onTap: () => _onTapTaskStatus(TaskType.tNew, 'New'),
              ),
              ListTile(
                title: Text('Progress'),
                trailing: _getTaskStatusTrailing(TaskType.progress),
                onTap: () => _onTapTaskStatus(TaskType.progress, 'Progress'),
              ),
              ListTile(
                title: Text('Completed'),
                trailing: _getTaskStatusTrailing(TaskType.completed),
                onTap: () => _onTapTaskStatus(TaskType.completed, 'Completed'),
              ),
              ListTile(
                title: Text('Cancelled'),
                trailing: _getTaskStatusTrailing(TaskType.cancelled),
                onTap: () => _onTapTaskStatus(TaskType.cancelled, 'Cancelled'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _getTaskStatusTrailing(TaskType type) {
    return widget.taskType == type ? Icon(Icons.check) : null;
  }

  void _onTapTaskStatus(TaskType type, String status) {
    if (type == widget.taskType) {
      return;
    }
    _updateTaskStatus(status);
  }

  Future<void> _updateTaskStatus(String status) async {
    Navigator.pop(context);
    _updateTaskStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
    );
    if (response.success) {
      widget.onStatusUpdate();
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
    _updateTaskStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _onDeletePressed() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Task'),
            content: Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      _deleteTask();
    }
  }

  Future<void> _deleteTask() async {
    _deleteTaskInProgress = true;
    if (mounted) setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTaskUrl(widget.taskModel.id),
    );

    _deleteTaskInProgress = false;
    if (mounted) setState(() {});

    if (response.success) {
      widget.onDelete();
      if (mounted) {
        showSnackBarMessage(context, 'Task deleted successfully.');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to delete task. Please try again.',
        );
      }
    }
  }
}
