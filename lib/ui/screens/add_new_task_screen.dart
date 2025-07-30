import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_bg.dart';

import '../widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  static const String routeName = '/add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBg(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Add New Task',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                  maxLines: 5,
                  decoration: InputDecoration(hintText: 'Description'),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _onTapAddNewTaskButton,
                  child: Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapAddNewTaskButton() {
    if (_formKey.currentState!.validate()) {
      // TODO: Sign in with API
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
