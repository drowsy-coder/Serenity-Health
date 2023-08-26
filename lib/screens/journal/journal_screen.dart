import 'package:flutter/material.dart';
import 'package:dart_sentiment/dart_sentiment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final Sentiment sentiment = Sentiment();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  int negativeEntryCount = 0;
  DateTime lastNegativeEntryTime = DateTime.now();

  String? _uid;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          _uid = user.uid;
        });
      } else {
        setState(() {
          _uid = null;
        });
      }
    });
  }

  void analyzeSentiment(String title, String text) async {
    if (_uid == null) {
      return;
    }

    Map<String, dynamic> analysis = sentiment.analysis(text);
    double score = analysis['score'].toDouble();

    String sentimentText = interpretScore(score);
    String emoji = getEmojiForSentiment(score);

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('journal_entries')
        .add({
      'title': title,
      'text': text,
      'score': score,
      'sentiment': sentimentText,
      'emoji': emoji,
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (score < -0.2) {
      DateTime currentTime = DateTime.now();
      if (currentTime.difference(lastNegativeEntryTime).inDays <= 7) {
        negativeEntryCount++;
        if (negativeEntryCount >= 3) {
          showHelpAlert();
        }
      } else {
        negativeEntryCount = 1;
      }
      lastNegativeEntryTime = currentTime;
    }

    _titleController.clear();
    _textController.clear();
  }

  void showHelpAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Seek Help"),
          content: const Text(
              "It seems like you've had very negative entries three times in a week. Consider seeking help at https://www.betterhelp.com"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Dismiss"),
            ),
          ],
        );
      },
    );
  }

  String interpretScore(double score) {
    if (score > 0.2) {
      return "Very Positive";
    } else if (score > 0) {
      return "Positive";
    } else if (score < -0.2) {
      return "Very Negative";
    } else if (score < 0) {
      return "Negative";
    } else {
      return "Neutral";
    }
  }

  String getEmojiForSentiment(double score) {
    if (score > 0.2) {
      return '😄';
    } else if (score > 0) {
      return '🙂';
    } else if (score < -0.2) {
      return '😔';
    } else if (score < 0) {
      return '😞';
    } else {
      return '😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entry'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: const TextStyle(color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _textController,
              style: const TextStyle(fontSize: 16),
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Write your journal entry',
                labelStyle: const TextStyle(color: Colors.yellow),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.yellow),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  analyzeSentiment(_titleController.text, _textController.text);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Add Journal Entry',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Icon(
                  Icons.book,
                  size: 24,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  'Journal Entries:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _uid != null
                  ? _firestore
                      .collection('users')
                      .doc(_uid)
                      .collection('journal_entries')
                      .orderBy('timestamp', descending: true)
                      .snapshots()
                  : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                      child: Text('No journal entries available.'));
                }

                List<QueryDocumentSnapshot<Map<String, dynamic>>> entries =
                    snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      var entry = entries[index].data();
                      String text = entry['text'] ?? '';
                      String title = entry['title'] ?? '';
                      String sentimentText = entry['sentiment'] ?? '';
                      String emoji = entry['emoji'] ?? '';

                      return Card(
                        elevation: 10,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  emoji,
                                  style: const TextStyle(
                                    fontSize: 36,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      text,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      sentimentText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
