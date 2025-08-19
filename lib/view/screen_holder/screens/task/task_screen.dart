import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        taskViewModel.fetchTaskStatus();
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
        taskViewModel.fetchTaskStatus(); // Fetch employer summaries
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

  String _formatTaskStatus(String? status, bool? hasEntry) {
    // Convert API status to user-friendly display format
    if (hasEntry == true) {
      return 'Completed';
    }

    switch (status?.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Ongoing';
      case 'ongoing':
        return 'Ongoing';
      case 'in_progress':
        return 'Ongoing';
      default:
        return status?.toString().toUpperCase() ?? 'Unknown';
    }
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
                    // Ongoing - Show summaries + ongoing tasks
                    _buildTaskList(
                      getFilteredTasksByTab('Ongoing'),
                      showSummaries: true,
                    ),
                    // Completed - Show only completed tasks
                    _buildTaskList(
                      getFilteredTasksByTab('Completed'),
                      showSummaries: false,
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(
    List<Map<String, dynamic>> taskList, {
    bool showSummaries = false,
  }) {
    print(
      '🔍 _buildTaskList called with ${taskList.length} tasks, showSummaries: $showSummaries',
    );
    print('🔍 Tasks: $taskList');
    print('🔍 taskStatusSummary: ${taskViewModel.taskStatusSummary}');

    // For completed tab, we want to show ALL completed tasks, not just filtered ones
    List<Map<String, dynamic>> tasksToShow = taskList;

    if (!showSummaries) {
      // If this is the completed tab, show all completed tasks from the full task list
      tasksToShow = taskViewModel.tasks.where((task) {
        final taskStatus = task['status'] ?? '';
        final hasEntry = task['has_entry'] ?? false;
        // Show completed tasks (either marked as completed or has entry)
        return taskStatus == 'completed' || hasEntry == true;
      }).toList();

      print('🔍 All completed tasks: ${tasksToShow.length}');
    }

    if (tasksToShow.isEmpty && !showSummaries) {
      return Center(
        child: Text(
          'No tasks found.',
          style: GoogleFonts.poppins(color: AppColor.whiteColor),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await taskViewModel.fetchTasks(); // Fetch individual tasks
        await taskViewModel.fetchTaskStatus(); // Fetch employer summaries
      },
      child: ListView(
        children: [
          // Show employer summaries at the top (only for Ongoing tab)
          if (showSummaries &&
              taskViewModel.taskStatusSummary['employer_all_summary'] != null)
            ...List<Map<String, dynamic>>.from(
              taskViewModel.taskStatusSummary['employer_all_summary'],
            ).map((employerData) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TaskBlock(
                  id: int.tryParse(employerData['employer_id'].toString()),
                  title:
                      '📊 ${employerData['employer_name'] ?? 'Unknown Employer'}',
                  startDate: _formatDate(employerData['from_date']),
                  status: 'Summary',
                  count: employerData['completed'] ?? 0,
                  endDate: _formatDate(employerData['to_date']),
                  profileImage: 'https://i.pravatar.cc/300',
                  progress:
                      (double.tryParse(employerData['percentage'].toString()) ??
                          0.0) /
                      100.0,
                  totalTasks: employerData['total'] ?? 0,
                  onTap: () {
                    print(
                      'Employer summary tapped: ${employerData['employer_name']}',
                    );
                  },
                ),
              );
            }).toList(),

          // Show individual tasks for this tab
          ...tasksToShow.map((task) {
            String taskStatus = _formatTaskStatus(
              task['status'],
              task['has_entry'],
            );
            return TaskBlock(
              id: int.tryParse(task['id'].toString()),
              title: task['job_title'] ?? 'Untitled Task',
              startDate: _formatDate(task['task_date_time']),
              status: taskStatus,
              count: task['has_entry'] == true ? 1 : 0,
              endDate: _formatDate(task['task_end_date_time']),
              profileImage: 'https://i.pravatar.cc/300',
              progress: task['has_entry'] == true ? 1.0 : 0.0,
              totalTasks: 1,
              onTap: () {
                print(
                  'Task tapped: ${task['job_title']} - Status: $taskStatus',
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
