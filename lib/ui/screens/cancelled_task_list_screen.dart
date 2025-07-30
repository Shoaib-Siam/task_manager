import 'package:flutter/material.dart';

import '../widgets/task_card.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return TaskCard(
            taskType: TaskType.Canceled,
          );
        },
      ),
    );
  }
}
