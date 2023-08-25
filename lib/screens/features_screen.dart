import 'package:serenity/screens/health_features/medicine_reminder/medication_reminder.dart';
import 'package:serenity/screens/health_features/menstrual_tracker/menstrual_tracker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:serenity/screens/mental_health/journal_screen.dart';
// import 'package:serenity/screens/mental_health/meditation_screen.dart';
// import 'package:serenity/screens/physical_health/widgets/menstrual_tracker.dart';

class FeaturesScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  FeaturesScreen({super.key});

  Future<bool> _getUserGender() async {
    final DocumentSnapshot snapshot =
        await firestore.collection('users').doc(user?.uid).get();
    final Map<String, dynamic>? userData =
        snapshot.data() as Map<String, dynamic>?; // Explicit casting
    final bool? isFemale = userData?['isFemale'];
    return isFemale ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Health Toolbox',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber[700], // Set the app bar color
        iconTheme: const IconThemeData(
          color: Colors.black, // Set the color of the back arrow
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              Card(
                color: Colors.blueAccent, // Set the card background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                child: ListTile(
                  title: const Text(
                    'Medication Reminders',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white, // Set the title text color
                    ),
                  ),
                  subtitle: const Text(
                    'Set reminders for your medications',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70, // Set the subtitle text color
                    ),
                  ),
                  leading: const Icon(
                    Icons.medical_services,
                    color: Colors.white, // Set the leading icon color
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white, // Set the trailing icon color
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicationRemindersScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                color: Colors.purple, // Set the card background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),

                elevation: 4,
                child: ListTile(
                  title: const Text(
                    'Meditation',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white, // Set the title text color
                    ),
                  ),
                  subtitle: const Text(
                    'Meditate to relax your mind and body',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70, // Set the subtitle text color
                    ),
                  ),
                  leading: const Icon(
                    Icons.spa,
                    color: Colors.white, // Set the leading icon color
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white, // Set the trailing icon color
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MeditationScreen(),
                    //   ),
                    // );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                color: Colors.green, // Set the card background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                child: ListTile(
                  title: const Text(
                    'Journal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white, // Set the title text color
                    ),
                  ),
                  subtitle: const Text(
                    'Journal your thoughts and feelings',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70, // Set the subtitle text color
                    ),
                  ),
                  leading: const Icon(
                    Icons.book,
                    color: Colors.white, // Set the leading icon color
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white, // Set the trailing icon color
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => JournalScreen(),
                    //   ),
                    // );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<bool>(
                future: _getUserGender(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return Card(
                      color: Colors.deepOrange, // Set the card background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: const Text(
                          'Menstrual Cycle Tracker',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white, // Set the title text color
                          ),
                        ),
                        subtitle: const Text(
                          'Track your menstrual cycle',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Colors.white70, // Set the subtitle text color
                          ),
                        ),
                        leading: const Icon(
                          Icons.calendar_today,
                          color: Colors.white, // Set the leading icon color
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white, // Set the trailing icon color
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MenstrualCycleTrackerScreen(),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[900], // Set the screen background color
    );
  }
}
