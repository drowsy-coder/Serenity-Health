import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReminderListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reminders')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Convert each document snapshot into a Reminder object
          List<Reminder> reminders = snapshot.data!.docs
              .map((doc) => Reminder.fromSnapshot(doc))
              .toList();

          if (reminders.isEmpty) {
            return const Center(
              child: Text('No reminders found'),
            );
          }

          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              Reminder reminder = reminders[index];

              // Format the date
              String formattedDate = _formatDate(reminder.selectedDate);

              // Format the time
              String formattedTime = _formatTime(reminder.selectedTime);

              return Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Image.asset(
                    'assets/images/medicines.png',
                    width: 48,
                    height: 48,
                  ),
                  title: Text(
                    reminder.medicationName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Till: $formattedDate',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Time: $formattedTime',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Error fetching reminders');
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // Format the date as "12th of June"
  String _formatDate(DateTime date) {
    String day = date.day.toString();
    String month = _getMonthName(date.month);
    String suffix = _getNumberSuffix(date.day);
    return '$day$suffix of $month';
  }

  // Get the month name from the month number
  String _getMonthName(int month) {
    const List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[month - 1];
  }

  // Get the appropriate suffix for a number
  String _getNumberSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // Format the time as "HH:MM"
  String _formatTime(DateTime time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class Reminder {
  final String medicationName;
  final DateTime selectedDate;
  final DateTime selectedTime;

  Reminder({
    required this.medicationName,
    required this.selectedDate,
    required this.selectedTime,
  });

  // Create a Reminder object from a Firestore document snapshot
  factory Reminder.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Reminder(
      medicationName: data['medicationName'],
      selectedDate: (data['selectedDate'] as Timestamp).toDate(),
      selectedTime: (data['selectedTime'] as Timestamp).toDate(),
    );
  }
}
