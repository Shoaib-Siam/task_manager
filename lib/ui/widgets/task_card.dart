import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';

enum TaskType {
  New,
  Progress,
  Completed,
  Canceled,
}

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.taskType, required this.taskModel});

  final TaskType taskType;
  final TaskModel taskModel;
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
              taskModel.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              taskModel.description,
              style: TextStyle(color: Colors.grey),
            ),
            Text('Date: ${taskModel.createdDate}'),
            SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(_getTaskTypeName(), style: TextStyle(color: Colors.white)),
                  backgroundColor: _getTaskChipColor(),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Color _getTaskChipColor(){

    switch (taskType){
      case TaskType.New:
        return Colors.blue;
      case TaskType.Progress:
        return Colors.purple;
      case TaskType.Completed:
        return Colors.green;
      case TaskType.Canceled:
        return Colors.red;
    }
  }
  String _getTaskTypeName(){
    switch (taskType){

      case TaskType.New:
        return 'New';
      case TaskType.Progress:
        return 'Progress';
      case TaskType.Completed:
        return 'Completed';
      case TaskType.Canceled:
        return 'Canceled';
    }
  }
}
