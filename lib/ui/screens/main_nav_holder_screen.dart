import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/progress_task_%20list_screen.dart';

import '../widgets/tm_app_bar.dart';
import 'cancelled_task_list_screen.dart';
import 'completed_task_list_screen.dart';
import 'new_task_list_screen.dart';

class MainNavHolderScreen extends StatefulWidget {
  const MainNavHolderScreen({super.key});
  static const String routeName = '/main-nav-holder';

  @override
  State<MainNavHolderScreen> createState() => _MainNavHolderScreenState();
}

class _MainNavHolderScreenState extends State<MainNavHolderScreen> {
  List<Widget> _pages = [
    NewTaskListScreen(),
    ProgressTaskListScreen(),
    CompletedTaskListScreen(),
    CancelledTaskListScreen(),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.new_label_outlined),
            label: 'New',
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_circle_right_outlined),
            label: 'Progress',
          ),
          NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
          NavigationDestination(
            icon: Icon(Icons.cancel_outlined),
            label: 'Canceled',
          ),
        ],
      ),
    );
  }
}
