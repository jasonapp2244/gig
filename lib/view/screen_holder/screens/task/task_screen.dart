import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/view_models/controller/task/delete_tast_view_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/components/task_block.dart';
import '../../../../view_models/controller/task/get_task_view_model.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchText = '';
  final GetTaskViewModel taskViewModel = Get.put(GetTaskViewModel());
  bool _isInitialized = false; // Track if screen has been initialized

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only refresh tasks when screen becomes visible and tasks list is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && taskViewModel.tasks.isEmpty && !_isInitialized) {
        taskViewModel.fetchTasks();
        _isInitialized = true;
      }
    });
  }

  final List<String> tabs = ['Ongoing', 'Completed'];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
    // Only refresh if tasks list is empty and not already initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && taskViewModel.tasks.isEmpty && !_isInitialized) {
        taskViewModel.fetchTasks();
        _isInitialized = true;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredTasks =>
      taskViewModel.getFilteredTasks(searchText);

  List<Map<String, dynamic>> getFilteredTasksByTab(String status) {
    return taskViewModel.getTasksByStatus(status);
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString == 'N/A') return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  String _mapStatus(String? status, bool? hasEntry) {
    if (hasEntry == true) return 'Completed';
    if (status == 'pending') return 'Ongoing';
    return status ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: AppColor.appBodyBG,
        elevation: 0,

        centerTitle: true,
        title: Text(
          'Tasks',
          style: TextStyle(
            color: AppColor.secondColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Column(
          children: [
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
                  hintText:
                      'Search by job title, employer, location, or status...',
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,

                unselectedLabelColor: Colors.white,
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
              child: Obx(() {
                if (taskViewModel.loading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primeColor,
                    ),
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    // Ongoing
                    _buildTaskList(getFilteredTasksByTab('Ongoing')),
                    // Completed
                    _buildTaskList(getFilteredTasksByTab('Completed')),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Map<String, dynamic>> taskList) {
    if (taskList.isEmpty) {
      return Center(
        child: Text(
          'No tasks found.',
          style: GoogleFonts.poppins(color: AppColor.whiteColor),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await taskViewModel.fetchTasks(); // Use fetchTasks to avoid snackbar
      },
      child: ListView(
        children: taskList.map((task) {
          return TaskBlock(
            id: task['id'],
            title: task['job_title'] ?? 'Untitled Task',
            startDate: _formatDate(task['task_date_time']),
            status: _mapStatus(task['status'], task['has_entry']),
            endDate: _formatDate(task['task_end_date_time']),
            profileImage: 'https://i.pravatar.cc/300',
            progress: task['has_entry'] == true ? 1.0 : 0.0,
            completedTasks: task['has_entry'] == true ? 1 : 0,
            totalTasks: 1,
            onTap: () {
              // Handle task tap
            },
          );
        }).toList(),
      ),
    );
  }
}
