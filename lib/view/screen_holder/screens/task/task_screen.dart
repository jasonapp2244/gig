import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/components/task_block.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchText = '';

  final List<String> tabs = ['Ongoing', 'Incomplete', 'Completed'];

  // Update status based on endDate
  void updateTaskStatuses() {
    final now = DateTime.now();

    for (var task in tasks) {
      DateTime startDate = _parseDate(task['startDate']);
      DateTime endDate = _parseDate(task['endDate']);

      if (task['progress'] == 1.0) {
        task['status'] = 'Completed';
      } else if (now.isBefore(startDate)) {
        task['status'] = 'Ongoing'; // Will start later
      } else if (now.isAfter(endDate)) {
        task['status'] = 'Incomplete'; // Date passed, not complete
      } else {
        task['status'] = 'Ongoing'; // In progress
      }
    }
  }

  // Parse date helper
  DateTime _parseDate(String dateString) {
    List<String> parts = dateString.split('/');
    return DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[0]), // month
      int.parse(parts[1]), // day
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    updateTaskStatuses(); // 👈 Move here
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'On going Task',
      'startDate': '06/12/2025',
      'endDate': '06/13/2025',
      'status': 'Ongoing', // 👈 Add this
      'profileImage': 'https://i.pravatar.cc/300',
      'progress': 0.5,
      'completedTasks': 24,
      'totalTasks': 48,
    },
    {
      'title': 'Mane Kit',
      'startDate': '01/01/2021',
      'endDate': '01/02/2021',
      'status': 'Incomplete', // 👈 Add this
      'profileImage': 'https://i.pravatar.cc/300',
      'progress': 0.5,
      'completedTasks': 24,
      'totalTasks': 48,
    },
    {
      'title': 'Test Task',
      'startDate': '01/03/2021',
      'endDate': '01/04/2021',
      'status': 'Completed', // 👈 Another example
      'profileImage': 'https://i.pravatar.cc/301',
      'progress': 1.0,
      'completedTasks': 48,
      'totalTasks': 48,
    },
  ];


  String searchQuery = '';

  List<Map<String, dynamic>> get filteredTasks => tasks
  .where((task) =>
      task['title'].toLowerCase().contains(searchText.toLowerCase()) ||
      task['startDate'].contains(searchText) ||
      task['endDate'].contains(searchText) ||
      task['status'].toLowerCase().contains(searchText.toLowerCase()))
  .toList();

  List<Map<String, dynamic>> getFilteredTasksByTab(String status) {
    return filteredTasks.where((task) => task['status'] == status).toList();
  }


  @override
  Widget build(BuildContext context) {
    updateTaskStatuses();
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, color: AppColor.primeColor),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 35,
                  left: 35,
                  child: Text(
                    'Task',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.secondColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),

            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by task name, date, or status...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // remove underline
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            // Tabs with custom style
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  color: AppColor.primeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicatorSize: TabBarIndicatorSize.tab,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: tabs.map((tab) => Tab(text: tab)).toList(),
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Ongoing
                  _buildTaskList(getFilteredTasksByTab('Ongoing')),
                  // Incomplete
                  _buildTaskList(getFilteredTasksByTab('Incomplete')),
                  // Completed
                  _buildTaskList(getFilteredTasksByTab('Completed')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Map<String, dynamic>> taskList) {
    if (taskList.isEmpty) {
      return Center(child: Text('No tasks found.',style: GoogleFonts.poppins(color: AppColor.whiteColor),));
    }

    return ListView(
      children: taskList.map((task) {
        return TaskBlock(
          title: task['title'],
          startDate: task['startDate'],
          status: task['status'],
          endDate: task['endDate'],
          profileImage: task['profileImage'],
          progress: task['progress'],
          completedTasks: task['completedTasks'],
          totalTasks: task['totalTasks'],
          onTap: () {
            // Handle task tap
          },
        );
      }).toList(),
    );
  }
}