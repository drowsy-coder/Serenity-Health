import 'package:serenity/screens/health_features/medicine_reminder/medication_reminders_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MedicationRemindersScreen extends StatefulWidget {
  const MedicationRemindersScreen({super.key});

  @override
  _MedicationRemindersScreenState createState() =>
      _MedicationRemindersScreenState();
}

class _MedicationRemindersScreenState extends State<MedicationRemindersScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController medicationNameController = TextEditingController();

  Future<void> _uploadFormData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      // Get a reference to the Firestore collection
      CollectionReference remindersCollection =
          FirebaseFirestore.instance.collection('reminders');

      // Convert selectedDate to Timestamp
      Timestamp? dateTimestamp;
      if (selectedDate != null) {
        dateTimestamp = Timestamp.fromDate(selectedDate!);
      }

      // Convert selectedTime to Timestamp
      Timestamp? timeTimestamp;
      if (selectedTime != null) {
        final now = DateTime.now();
        final selectedDateTime = DateTime(now.year, now.month, now.day,
            selectedTime!.hour, selectedTime!.minute);
        timeTimestamp = Timestamp.fromDate(selectedDateTime);
      }

      // Create a new document in the collection
      await remindersCollection.add({
        'userId': currentUser?.uid,
        'medicationName': medicationNameController.text,
        'selectedDate': dateTimestamp,
        'selectedTime': timeTimestamp,
      });

      // Reset the input fields
      medicationNameController.clear();
      setState(() {
        selectedDate = null;
        selectedTime = null;
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form data uploaded successfully')),
      );
    } catch (error) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _openTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  void dispose() {
    medicationNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Tracker'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Colors.grey[900], // Set a dark background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0), // Remove the padding
                  child: TextField(
                    controller: medicationNameController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ), // Set the text color and size
                    decoration: InputDecoration(
                      labelText: 'Medication Name',
                      labelStyle: TextStyle(
                        color: Colors.grey[400], // Set the label text color
                        fontSize: 16.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color:
                              Colors.red, // Set the border color when focused
                          width: 2.0,
                        ),
                        borderRadius:
                            BorderRadius.circular(10), // Apply border radius
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[
                              600]!, // Set the border color when enabled
                          width: 1.0,
                        ),
                        borderRadius:
                            BorderRadius.circular(10), // Apply border radius
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.grey[900],
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  title: const Text(
                    'Reminder Time',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedTime == null
                            ? 'Select time'
                            : 'Time: ${selectedTime!.format(context)}',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      // Text(
                      //   'Tap to select time',
                      //   style:
                      //       TextStyle(fontSize: 14, color: Colors.grey[400]),
                      // ),
                    ],
                  ),
                  trailing: const Icon(Icons.access_time, color: Colors.green),
                  onTap: _openTimePicker,
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.grey[900],
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  title: const Text(
                    'Medication Reminders',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDate == null
                            ? 'From'
                            : 'Date: ${selectedDate.toString().substring(0, 10)}',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      // Text(
                      //   'Tap to select date',
                      //   style: TextStyle(fontSize: 14, color: Colors.grey),
                      // ),
                    ],
                  ),
                  trailing: const Icon(Icons.calendar_today, color: Colors.amber),
                  onTap: _openDatePicker,
                ),
              ),
              ElevatedButton(
                // Make it span the entire width
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.purple[900],
                ),
                onPressed: _uploadFormData,
                child: const Text('Create Reminder'),
              ),
              const SizedBox(height: 16.0),
              const SizedBox(
                height: 500,
                child: ReminderListWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
