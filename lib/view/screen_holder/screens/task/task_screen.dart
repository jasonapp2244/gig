import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/components/all_tasks_widget.dart';
import 'package:gig/res/components/bottom_banner_ads.dart';
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

    // Always refresh task status data when screen becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isInitialized) {
        print('🔄 TaskScreen - Initializing data');
        taskViewModel.refreshData();
        _isInitialized = true;
      }
    });

    // Add focus listener to refresh when screen comes into focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Listen for when this screen becomes visible
        final route = ModalRoute.of(context);
        if (route != null && route.isCurrent) {
          // Screen is currently visible - refresh data silently
          print('🔄 TaskScreen - Screen focused, refreshing task status data');
          taskViewModel
              .fetchTaskStatus(); // Only fetch task status, not full refresh
        }
      }
    });
  }

  final List<String> tabs = ['Ongoing', 'Incomplete', 'Completed'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    // Initialize data immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isInitialized) {
        print('🔄 TaskScreen - initState: Initializing task status data');
        taskViewModel.fetchTaskStatus(); // Fetch task status data immediately
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

  // Updated method to get tasks filtered by status using employer_status_summary
  List<Map<String, dynamic>> getFilteredTasksByTab(String status) {
    print('🔍 getFilteredTasksByTab called with status: $status');

    // For Incomplete tab, show individual task cards instead of employer summaries
    if (status == 'Incomplete' || status == 'pending') {
      // List<Map<String, dynamic>> individualTasks = taskViewModel
      //     .getTasksByStatusFromSummary(status);

      //  print('🔍 Individual tasks count: ${individualTasks.length}');

      // Apply search filter on individual tasks
      if (searchText.isEmpty) {
        print('🔍 No search text, returning all individual tasks');
        //  return individualTasks;
      }

      print('🔍 Applying search filter with text: $searchText');
    }

    // For other tabs, get employer summaries grouped by employer
    List<Map<String, dynamic>> employerSummaries = taskViewModel
        .getEmployerSummariesByStatus(status);

    print('🔍 Employer summaries count: ${employerSummaries.length}');

    // Apply search filter on top of employer summaries
    if (searchText.isEmpty) {
      print('🔍 No search text, returning all employer summaries');
      return employerSummaries;
    }

    print('🔍 Applying search filter with text: $searchText');

    List<Map<String, dynamic>> searchFilteredSummaries = employerSummaries
        .where((summary) {
          final employerName = (summary['employer_name'] ?? '')
              .toString()
              .toLowerCase();
          final summaryText = (summary['summary_text'] ?? '')
              .toString()
              .toLowerCase();
          final status = (summary['status'] ?? '').toString().toLowerCase();
          final searchLower = searchText.toLowerCase();

          return employerName.contains(searchLower) ||
              summaryText.contains(searchLower) ||
              status.contains(searchLower);
        })
        .toList();

    print(
      '🔍 Search filtered employer summaries count: ${searchFilteredSummaries.length}',
    );
    return searchFilteredSummaries;
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
      case 'incomplete':
      case 'pending':
        return 'Incomplete';
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
        backgroundColor: AppColor.appBodyBG,
        elevation: 0,

        centerTitle: true,
        title: Text(
          'Work History',
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
                    // Ongoing - Show ongoing tasks from employer_status_summary
                    _buildTaskList(
                      getFilteredTasksByTab('Ongoing'),
                      showSummaries: false,
                      currentTabStatus: 'Ongoing',
                    ),
                    _buildTaskList(
                      getFilteredTasksByTab('Incomplete'),
                      showSummaries: false,
                      currentTabStatus: 'Incomplete',
                    ),
                    // Com
                    // Completed - Show completed tasks from employer_status_summary
                    _buildTaskList(
                      getFilteredTasksByTab('Completed'),
                      showSummaries: false,
                      currentTabStatus: 'Completed',
                    ),
                  ],
                );
              }),
            ),BottomBannerAd(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(
    List<Map<String, dynamic>> taskList, {
    bool showSummaries = false,
    String? currentTabStatus, // Add current tab status parameter
  }) {
    print(
      '🔍 _buildTaskList called with ${taskList.length} tasks, showSummaries: $showSummaries, currentTabStatus: $currentTabStatus',
    );
    print('🔍 Tasks: $taskList');
    print('🔍 taskStatusSummary: ${taskViewModel.taskStatusSummary}');
    print(
      '🔍 taskStatusSummary.isEmpty: ${taskViewModel.taskStatusSummary.isEmpty}',
    );
    print('🔍 taskStatusSummary.keys: ${taskViewModel.taskStatusSummary.keys}');

    // Use the filtered task list directly
    List<Map<String, dynamic>> tasksToShow = taskList;
    taskViewModel.status.value = currentTabStatus.toString();

    if (tasksToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No tasks found.',
              style: GoogleFonts.poppins(color: AppColor.whiteColor),
            ),
            SizedBox(height: 10),
            Text(
              'Status: ${taskViewModel.statusLoading.value ? "Loading..." : "No data"}',
              style: GoogleFonts.poppins(
                color: AppColor.whiteColor.withOpacity(0.7),
              ),
            ),
            if (!taskViewModel.statusLoading.value)
              ElevatedButton(
                onPressed: () {
                  print('🔄 Manual refresh triggered');
                  taskViewModel.fetchTaskStatus();
                },
                child: Text('Refresh'),
              ),
          ],
        ),
      );
    }

    // Check if we're showing individual tasks (for Incomplete tab) or employer summaries

    return RefreshIndicator(
      onRefresh: () async {
        await taskViewModel.refreshData(); // Use the new refresh method
      },
      child: ListView(
        children: [
          // Show employer summaries grouped by employer (for Ongoing and Completed tabs)
          ...tasksToShow.map((summaryData) {
            String taskStatus = _formatTaskStatus(
              summaryData['status'],
              summaryData['has_entry'],
            );

            // Determine the correct count based on the current tab, not the task status
            int displayCount;
            if (currentTabStatus == 'Ongoing') {
              displayCount =
                  int.tryParse(summaryData['ongoing']?.toString() ?? '0') ?? 0;
            } else if (currentTabStatus == 'Incomplete') {
              displayCount =
                  int.tryParse(summaryData['pending']?.toString() ?? '0') ?? 0;
            } else {
              displayCount =
                  int.tryParse(summaryData['completed']?.toString() ?? '0') ??
                  0;
            }

            // Debug logging to see what values we're getting

            return TaskBlock(
              id: int.tryParse(summaryData['employer_id']?.toString() ?? '0'),
              title: '${summaryData['employer_name'] ?? 'Unknown Employer'}',
              startDate: _formatDate(summaryData['from_date']),
              status: taskStatus,
              count: displayCount, // Use the correct count based on current tab
              endDate: _formatDate(summaryData['to_date']),
              profileImage: 'https://i.pravatar.cc/300',
              progress:
                  (double.tryParse(
                        summaryData['percentage']?.toString() ?? '0',
                      ) ??
                      0.0) /
                  100.0,
              totalTasks:
                  int.tryParse(summaryData['total']?.toString() ?? '1') ?? 1,
              employer: summaryData['employer_name'] ?? '',
              onTap: () {
                final employerId =
                    int.tryParse(summaryData['employer_id'].toString()) ?? 0;
                final status = currentTabStatus ?? "Ongoing";
                var model = Get.find<GetTaskViewModel>();

                print("employeer id $employerId");
                print("status .. $status");

                Get.to(
                  () => EmployerTaskListScreen(
                    employerId: employerId,
                    status: status.toLowerCase() == 'incomplete'
                        ? 'pending'
                        : status.toLowerCase(),
                    employerName: summaryData['employer_name'] ?? "Employer",
                    model: model,
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
