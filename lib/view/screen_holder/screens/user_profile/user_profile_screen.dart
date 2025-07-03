import 'package:flutter/material.dart';
import '../../../../res/colors/app_color.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User Image
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/300'), // Replace with actual image
              ),
              SizedBox(height: 12),

              // User Name
              Text(
                'Henry Kanwil',
                style: TextStyle(
                  color: AppColor.primeColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),

              // Sub Heading
              Text(
                'Lorem Ipsum',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),

              SizedBox(height: 6),
              Text(
                'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu',
                style: TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // Icons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.white),
                  SizedBox(width: 20),
                  Icon(Icons.email, color: Colors.white),
                  SizedBox(width: 20),
                  Icon(Icons.location_on, color: Colors.white),
                ],
              ),

              SizedBox(height: 30),

              // Resume Box
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.primeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("My Resume", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text("resume_name.pdf", style: TextStyle(color: Colors.black87)),
                      ],
                    ),
                    Icon(Icons.download, color: Colors.black),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Skills Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Skills',
                  style: TextStyle(
                    color: AppColor.secondColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Skill Grid
              Wrap(
                spacing: 10,
                runSpacing: 16,
                children: [
                  buildSkillBox("Flutter", 0.85),
                  buildSkillBox("Firebase", 0.75),
                  buildSkillBox("Laravel", 0.70),
                  buildSkillBox("UI/UX", 0.90),
                  buildSkillBox("API Integration", 0.80),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSkillBox(String skill, double percent) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(skill, style: TextStyle(color: Colors.white, fontSize: 13)),
          SizedBox(height: 6),
          LinearPercentIndicator(
            lineHeight: 6,
            percent: percent,
            backgroundColor: Colors.white30,
            progressColor: Colors.orange,
            barRadius: Radius.circular(6),
            animation: true,
          ),
        ],
      ),
    );
  }
}
