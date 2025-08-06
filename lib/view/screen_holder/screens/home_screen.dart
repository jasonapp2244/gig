import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/fonts/app_fonts.dart';
import 'package:gig/res/routes/routes_name.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../res/colors/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          spacing: 15,
          children: [
            SizedBox(height: 20,),
            Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat, // required
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                daysOfWeekVisible: true,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  Get.toNamed(RoutesName.addTaskScreen);
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: const BoxDecoration(
                    color: AppColor.primeColor,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    border: Border.all(color: AppColor.primeColor, width: 2),
                    color: const Color(0xFF2D2F3A),
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: const TextStyle(color: Colors.white),
                  weekendTextStyle: const TextStyle(color: Colors.white),
                  outsideDaysVisible: false,
                ),
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(color: Colors.white),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white70),
                  weekendStyle: TextStyle(color: Colors.white70),
                ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Get.toNamed(RoutesName.taskScreen);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  decoration: BoxDecoration(
                    color: AppColor.inputBGColor100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.white38),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(
                        LucideIcons.history400,
                        color: AppColor.textColor,
                        size: 25,
                      ),
                      Text(
                        'work history',
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontFamily: AppFonts.appFont,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Get.toNamed(RoutesName.incomeTracker);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  decoration: BoxDecoration(
                    color: AppColor.inputBGColor100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.white38),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(
                        LucideIcons.handCoins400,
                        color: AppColor.textColor,
                        size: 25,
                      ),
                      Text(
                        'Track Income',
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontFamily: AppFonts.appFont,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Get.toNamed(RoutesName.marketPlaceScreen);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  decoration: BoxDecoration(
                    color: AppColor.inputBGColor100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.white38),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(
                        LucideIcons.store400,
                        color: AppColor.textColor,
                        size: 25,
                      ),
                      Text(
                        'Marketplace',
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontFamily: AppFonts.appFont,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
