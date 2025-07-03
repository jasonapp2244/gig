import 'package:flutter/material.dart';
import '../../../../res/colors/app_color.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        'title': 'New message from John',
        'time': '2 min ago',
      },
      {
        'title': 'Your ad has been approved',
        'time': '10 min ago',
      },
      {
        'title': 'Your item has been sold',
        'time': '1 hour ago',
      },
      {
        'title': 'Reminder: Complete your profile',
        'time': 'Yesterday',
      },
    ];

    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      appBar: AppBar(
        backgroundColor: AppColor.appBodyBG,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: AppColor.secondColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.primeColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.primeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.notifications, color: Colors.black, size: 20),
                ),
                SizedBox(width: 12),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['title']!,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(height: 4),
                      Text(
                        notif['time']!,
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
