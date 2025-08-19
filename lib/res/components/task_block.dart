import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:gig/view_models/controller/task/delete_tast_view_model.dart';
import 'package:gig/view_models/controller/task/get_task_view_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'bottom_sheet.dart';

class TaskBlock extends StatelessWidget {
  int? id;
  final String title;
  final String startDate;
  final String endDate;
  final String profileImage;
  final double progress; // 0.0 to 1.0

  final int totalTasks;
  final int count;
  final String status;
  final VoidCallback onTap;

  TaskBlock({
    super.key,
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.profileImage,
    required this.progress,

    required this.totalTasks,
    required this.status,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final deleteTaskVM = Get.put(DeleteTaskViewModel());
    final GetTaskViewModel taskViewModel = Get.put(GetTaskViewModel());

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141C2F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and profile image
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(profileImage),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Dates row
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(startDate, style: TextStyle(color: Colors.grey.shade400)),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, color: Colors.amber, size: 16),
                const SizedBox(width: 6),
                Text(endDate, style: const TextStyle(color: Colors.amber)),
              ],
            ),
            const SizedBox(height: 12),
            // Progress bar
            Row(
              children: [
                Text(
                  "${(progress * 100).round()}%",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "$count/$totalTasks tasks",
                  style: const TextStyle(color: Colors.amber),
                ),
              ],
            ),
            if (status != 'Completed')
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  spacing: 20,
                  children: [
                    Icon(
                      LucideIcons.squarePen400,
                      color: Colors.green,
                      size: 20,
                    ),
                    Obx(
                      () => InkWell(
                        onTap: deleteTaskVM.loading.value
                            ? null
                            : () {
                                customBottomSheet(
                                  context,
                                  title: 'Are you sure you want to delete?',
                                  btnText1: 'Yes, Delete',
                                  btnText2: 'Cancel',
                                  onFirstTap: () async {
                                    await deleteTaskVM.deleteTask(id ?? 0);
                                    // The DeleteTaskViewModel will handle the refresh automatically
                                    print('Deleted!');
                                  },
                                  onSecondTap: () {
                                    print('Cancelled!');
                                  },
                                );
                              },
                        child: deleteTaskVM.loading.value
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red,
                                ),
                              )
                            : Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
