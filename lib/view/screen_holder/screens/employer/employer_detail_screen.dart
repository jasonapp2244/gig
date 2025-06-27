import 'package:flutter/material.dart';
import '../../../../res/colors/app_color.dart';

class EmployerDetailScreen extends StatefulWidget {
  const EmployerDetailScreen({super.key});


  @override
  State<EmployerDetailScreen> createState() => _EmployerDetailScreenState();
}

class _EmployerDetailScreenState extends State<EmployerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      appBar: AppBar(
        backgroundColor: AppColor.appBodyBG,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColor.primeColor),
        title: Text(
          'ABC Company',
          style: TextStyle(color: AppColor.secondColor, fontSize: 18,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 Job Type Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Job Type: Full Time", // Dynamically replaceable
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),

            SizedBox(height: 16),

            /// 🔹 Salary & Location
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Salary Row
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 20, color: Colors.white70),
                      SizedBox(width: 8),
                      Text(
                        '\$1000',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  /// Location Row
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 20, color: Colors.white70),
                      SizedBox(width: 8),
                      Text(
                        'xyz location #5464',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            /// 🔹 Job Description
            Text(
              "Job Description",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
              "Curabitur ac vestibulum metus. Nulla facilisi. Sed laoreet "
              "bibendum mauris, nec cursus ex.",
              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
