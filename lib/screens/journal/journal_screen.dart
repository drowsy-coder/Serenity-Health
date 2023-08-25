import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _selectedMoodIndex = -1;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.grey[900],
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                color: Colors.grey[800],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'New Entry',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'How was your mood today?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMoodButton(0, '😓'),
                          _buildMoodButton(1, '😊'),
                          _buildMoodButton(2, '😄'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _saveEntry(uid);
                          _clearFields();
                        },
                        child: const Text('Save Entry'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildEntryList(uid),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(int index, String emoji) {
    final isSelected = index == _selectedMoodIndex;
    final color = isSelected ? Colors.blue : Colors.grey;

    return IconButton(
      onPressed: () {
        setState(() {
          _selectedMoodIndex = index;
        });
      },
      icon: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
      color: color,
    );
  }

  Future<void> _saveEntry(String? uid) async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final mood = _selectedMoodIndex;

    if (title.isEmpty || description.isEmpty || mood == -1) {
      return;
    }

    final entry = {
      'uid': uid,
      'title': title,
      'description': description,
      'mood': mood,
      'timestamp': DateTime.now(),
    };

    final entryRef = FirebaseFirestore.instance.collection('entries');
    await entryRef.add(entry);
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedMoodIndex = -1;
    });
  }

  Widget _buildEntryList(String? uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('entries')
          .where('uid', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = snapshot.data?.docs ?? [];

        if (entries.isEmpty) {
          return const Center(child: Text('No entries found.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index].data() as Map<String, dynamic>;
            final title = entry['title'] ?? '';
            final description = entry['description'] ?? '';
            final mood = entry['mood'];
            final timestamp = entry['timestamp'] as Timestamp;

            final dateTime = timestamp.toDate();
            final formattedDate =
                '${dateTime.day}-${dateTime.month}-${dateTime.year}';

            return Card(
              elevation: 2,
              color: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                title: Text(
                  '$title : $formattedDate',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    // color: Colors.black,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: _buildMoodEmoji(mood),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMoodEmoji(int mood) {
    String emoji;
    String text;

    switch (mood) {
      case 0:
        emoji = '😓';
        text = 'Bad';
        break;
      case 1:
        emoji = '😊';
        text = 'Neutral';
        break;
      case 2:
        emoji = '😄';
        text = 'Good';
        break;
      default:
        emoji = '😐';
        text = 'Unknown';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
