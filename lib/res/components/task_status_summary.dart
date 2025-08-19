import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors/app_color.dart';

class TaskStatusSummary extends StatelessWidget {
  final Map<String, dynamic> statusData;
  final bool isLoading;

  const TaskStatusSummary({
    super.key,
    required this.statusData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.primeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.primeColor.withOpacity(0.3)),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColor.primeColor,
            strokeWidth: 2,
          ),
        ),
      );
    }

    // Debug: Show data keys even if empty
    print('🎨 TaskStatusSummary - statusData: $statusData');
    print('🎨 TaskStatusSummary - statusData.isEmpty: ${statusData.isEmpty}');
    print('🎨 TaskStatusSummary - statusData.keys: ${statusData.keys}');

    if (statusData.isEmpty) {
      // Show debug info instead of hiding completely
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Text(
          'Debug: Task Status Summary - No data available\nData keys: ${statusData.keys.toList()}',
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.primeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.primeColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with employer info
          Row(
            children: [
              Icon(
                Icons.business,
                color: AppColor.primeColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  statusData['employer_name']?.toString() ?? 'Unknown Employer',
                  style: GoogleFonts.poppins(
                    color: AppColor.primeColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${statusData['percentage']?.toString() ?? '0'}%',
                style: GoogleFonts.poppins(
                  color: AppColor.primeColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey.withOpacity(0.3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (statusData['percentage'] ?? 0) / 100.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColor.primeColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Task counts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                'Total',
                statusData['total']?.toString() ?? '0',
                AppColor.primeColor,
              ),
              _buildStatItem(
                'Completed',
                statusData['completed']?.toString() ?? '0',
                Colors.green,
              ),
              _buildStatItem(
                'Ongoing',
                statusData['ongoing']?.toString() ?? '0',
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Summary text
          if (statusData['summary_text'] != null)
            Text(
              statusData['summary_text'].toString(),
              style: GoogleFonts.poppins(
                color: AppColor.secondColor.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          
          // Date range
          if (statusData['from_date'] != null && statusData['to_date'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.date_range,
                    color: AppColor.secondColor.withOpacity(0.6),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${statusData['from_date']} to ${statusData['to_date']}',
                    style: GoogleFonts.poppins(
                      color: AppColor.secondColor.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColor.secondColor.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
