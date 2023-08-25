import 'package:serenity/models/home_card_item.dart';
import 'package:serenity/models/home_carousel_item.dart';
import 'package:serenity/screens/home/card_screen.dart';
import 'package:serenity/screens/home/slider_config.dart';
import 'package:serenity/widgets/popups/gender_selection.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final bool justLoggedIn;

  const HomePage({super.key, required this.justLoggedIn});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFemale = false;
  bool isPromptShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPromptStatus();
    });
  }

  Future<void> _checkPromptStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? promptShown = prefs.getBool('promptShown');

    if (promptShown == true) {
      setState(() {
        isPromptShown = true;
      });
    } else if (widget.justLoggedIn) {
      _showPrompt();
    }
  }

  Future<void> _showPrompt() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final gender = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return GenderSelectionDialouge();
      },
    );

    if (gender != null) {
      setState(() {
        isFemale = gender;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'isFemale': isFemale});
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('promptShown', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Column(
          children: [
            MyCarouselSlider(carouselItems: carouselItems),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('card-items')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final documents = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final document = documents[index];
                      final item = CardItem(
                        title: document['title'],
                        description: document['description'],
                        redirectLink: document['redirectLink'],
                        imageAssetPath: document['imageAssetPath'],
                        field: document['field'],
                      );

                      return CustomCard(
                        item: Item(
                          title: item.title,
                          description: item.description,
                          redirectLink: item.redirectLink,
                          imageAssetPath: item.imageAssetPath,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
