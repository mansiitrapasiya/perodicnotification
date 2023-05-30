import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DateTime> selectedDateTimes = [];

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      selectedDateTimes.add(selectedDateTime);
      saveData(selectedDateTimes);
    });
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getStringList('selectedDateTimes');
    if (savedData != null) {
      setState(() {
        selectedDateTimes = savedData
            .map((dateTimeString) => DateTime.parse(dateTimeString))
            .toList();
      });
    }
  }

  Future<void> saveData(List<DateTime> data) async {
    final prefs = await SharedPreferences.getInstance();
    final dataToSave =
        data.map((dateTime) => dateTime.toIso8601String()).toList();
    await prefs.setStringList('selectedDateTimes', dataToSave);
  }

  Future<void> deleteData(DateTime dateTime) async {
    setState(() {
      selectedDateTimes.remove(dateTime);
      saveData(selectedDateTimes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () {
              if (selectedDateTimes.isNotEmpty) {
                scheduleNotifications(selectedDateTimes);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications Scheduled')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Please select at least one date and time')),
                );
              }
            },
            child: const Text('Schedule Notifications'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectDateTime,
              child: const Text('Select Date and Time'),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: selectedDateTimes.length,
              itemBuilder: (context, index) {
                final selectedDateTime = selectedDateTimes[index];
                return ListTile(
                  trailing: IconButton(
                      onPressed: () {
                        deleteData(selectedDateTime);
                      },
                      icon: const Icon(Icons.delete)),
                  title: Text(
                    'Notification ${index + 1}: ${DateFormat('dd/MM/yyyy hh:mm:ss a').format(selectedDateTime)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void scheduleNotifications(List<DateTime> scheduledDateTimes) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    Timer.periodic(Duration(minutes: 1), (timer) async {
      final DateTime dateTime = DateTime.now().toLocal();

      // for (final scheduledDateTime in scheduledDateTimes) {
      final content = NotificationContent(
        id: 55,
        channelKey: 'basic_channel',
        title: 'Scheduled Notification',
        body: 'This is a scheduled notification',
        payload: {'uuid': 'user-profile-uuid'},
      );

      await AwesomeNotifications().createNotification(
        content: content,
        schedule: NotificationAndroidCrontab.minutely(
            referenceDateTime: scheduledDateTimes.last),
      );
    });
  }
}
