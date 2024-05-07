import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bloom/pages/chat/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PeriodCalenderPage extends StatefulWidget {
  const PeriodCalenderPage({super.key});

  @override
  State<PeriodCalenderPage> createState() => _PeriodCalenderPageState();
}

class _PeriodCalenderPageState extends State<PeriodCalenderPage> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late CalendarFormat _calendarFormat;
  List<DateTime> periodDates = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _calendarFormat = CalendarFormat.month;
    _loadPeriodDates();
  }

  Future<void> _loadPeriodDates() async {
    try {
      periodDates =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getPeriodData();
      setState(() {}); // Update UI after successful data retrieval
    } catch (error) {
      print('Error fetching period data: $error');
      // Handle error appropriately (e.g., display error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Calendar')),
        body: ListView(children: [
          TableCalendar<DateTime>(
            headerStyle: HeaderStyle(formatButtonVisible: false),
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            calendarFormat: _calendarFormat,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                for (DateTime d in periodDates) {
                  if (day.day == d.day &&
                      day.month == d.month &&
                      day.year == d.year) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 230, 123, 123),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                }
                return null;
              },
            ),
          )
        ]));
  }
}
