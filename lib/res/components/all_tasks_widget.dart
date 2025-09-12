import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:gig/res/components/specific_task_block.dart';
import 'package:gig/res/components/task_block.dart';
import 'package:gig/view_models/controller/task/get_task_view_model.dart';

class EmployerTaskListScreen extends StatelessWidget {
  final int employerId;
  final String status;
  final String employerName;
  GetTaskViewModel? model;

  EmployerTaskListScreen({
    required this.employerId,
    required this.status,
    required this.employerName,
    this.model,
  });
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
      backgroundColor: AppColor.appBodyBG,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: model?.fetchTasksByEmployer(
          employerId: employerId,
          status: status,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primeColor),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("❌ Error loading tasks"));
          }

          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return Center(child: Text("No tasks found"));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskSpecficBlock(
                id: int.tryParse(task['id']?.toString() ?? '0'),
                title: task['job_title'] ?? "Untitled Task",
                startDate: _formatDate(task['task_date_time']) ?? "N/A",
                endDate: _formatDate(task['task_end_date_time']) ?? "N/A",
                profileImage: 'https://i.pravatar.cc/300',
                employer: task['employer'],
                status: task['status'] ?? "Unknown",
                totalTasks: 1,
                count: 1,
              );
            },
          );
        },
      ),
    );
  }
}
