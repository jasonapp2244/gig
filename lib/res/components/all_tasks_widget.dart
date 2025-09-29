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
  final int employerId;
  final String status;
  final String employerName;
  GetTaskViewModel? model;

  EmployerTaskListScreen({
    super.key,
    required this.employerId,
    required this.status,
    required this.employerName,
    this.model,
  });

  @override
  State<EmployerTaskListScreen> createState() => _EmployerTaskListScreenState();
}

class _EmployerTaskListScreenState extends State<EmployerTaskListScreen> {

  @override
  void initState() {
    super.initState();
    // Fetch tasks after the widget is built using post frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.model != null) {
        widget.model!.fetchTasksByEmployer(
          employerId: widget.employerId,
          status: widget.status, // Use the API status directly (already converted in task_screen.dart)
        );
      }
    });
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
      ),
      backgroundColor: AppColor.primeColor,
      body: Obx(() {
        if (widget.model!.loading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColor.secondColor,
            ),
          );
        }

        if (widget.model!.tasks.isEmpty) {
          return const Center(child: Text("No tasks found"));
        }

        return ListView.builder(
          itemCount: widget.model!.tasks.length,
          itemBuilder: (context, index) {
            final task = widget.model!.tasks[index];
            return TaskSpecficBlock(
              employeerId: widget.employerId,
              id: int.tryParse(task['id']?.toString() ?? '0'),
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
