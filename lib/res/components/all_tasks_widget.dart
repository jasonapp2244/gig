import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/components/specific_task_block.dart';
import 'package:gig/view_models/controller/task/get_task_view_model.dart';

extension StringCasingExtension on String {
  /// Capitalize first letter, keep remainder as-is.
  String toCapitalized() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

class EmployerTaskListScreen extends StatefulWidget {
  final String employerId;
  final String status;
  // final String employerName;
  final GetTaskViewModel? model;

  EmployerTaskListScreen({
    super.key,
    required this.employerId,
    required this.status,
    // required this.employerName,
    this.model,
  });

  @override
  State<EmployerTaskListScreen> createState() => _EmployerTaskListScreenState();
}

class _EmployerTaskListScreenState extends State<EmployerTaskListScreen> {
  String _formatDate(String? dateString) {
    if (dateString == null || dateString == 'N/A') return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch tasks when screen opens
    // Initialize data immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.model != null) {
        _fetchTasks();
      }
    });
  }

  Future<void> _fetchTasks() async {
    try {
      await widget.model!.fetchTasksByEmployer(
        employerId: widget.employerId.toString(),
        status: widget.status, // Don't capitalize, use as-is
      );
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: AppColor.appBodyBG,
        elevation: 0,
        centerTitle: true,
        // title: Text(
        //   widget.employerName,
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 18,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
      backgroundColor: AppColor.appBodyBG,
      body: widget.model == null
          ? Center(
              child: Text(
                "Model not initialized",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : Obx(() {
              // Check the correct data source
              if (widget.model!.getEachTasks.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(color: AppColor.primeColor),
                );
              }

              return ListView.builder(
                itemCount: widget.model!.getEachTasks.length,
                itemBuilder: (context, index) {
                  final task = widget.model!.getEachTasks[index];
                  return TaskSpecficBlock(
                    employeerId: widget.employerId.toString(),
                    id: task['id'],
                    title: task['job_title'] ?? "Untitled Task",
                    startDate: _formatDate(task['task_date_time']),
                    endDate: _formatDate(task['task_end_date_time']),
                    profileImage: 'https://i.pravatar.cc/300',
                    employer: task['employer'],
                    status: task['status'] ?? "Unknown",
                    totalTasks: 1,
                    count: 1,
                  );
                },
              );
            }),
    );
  }
}