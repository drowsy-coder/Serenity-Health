import 'package:flutter/material.dart';
import 'package:dart_sentiment/dart_sentiment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final Sentiment sentiment = Sentiment();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int negativeEntryCount = 0;
  DateTime lastNegativeEntryTime = DateTime.now();

  void analyzeSentiment(String title, String text) async {
    Map<String, dynamic> analysis = sentiment.analysis(text);
    double score = analysis['score'].toDouble();

    String sentimentText = interpretScore(score);
    String emoji = getEmojiForSentiment(score);

    await _firestore.collection('journal_entries').add({
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
          title: Text("Seek Help"),
          content: Text(
              "It seems like you've had very negative entries three times in a week. Consider seeking help at https://www.betterhelp.com"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Dismiss"),
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
        title: Text('Journal Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _textController,
              style: TextStyle(fontSize: 16),
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Write your journal entry',
                labelStyle: TextStyle(color: Colors.yellow),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  analyzeSentiment(_titleController.text, _textController.text);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Add Journal Entry',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
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
            SizedBox(height: 8),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestore
                  .collection('journal_entries')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('No journal entries available.'));
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
                        margin: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 10,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  emoji,
                                  style: TextStyle(
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      text,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      sentimentText,
                                      style: TextStyle(
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
