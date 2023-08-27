import 'package:delayed_display/delayed_display.dart';
import 'package:serenity/map_screen.dart';
import 'package:serenity/screens/Sakhi/chat_screen.dart';
import 'package:serenity/screens/SoS/sos_location.dart';
import 'package:serenity/widgets/buttons/sign_out_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF65C7C8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser?.photoURL ?? '',
                    ),
                    radius: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              FirebaseAuth.instance.currentUser?.displayName ??
                                  'Username',
                              textStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              speed: const Duration(milliseconds: 50),
                            ),
                          ],
                          totalRepeatCount: 1,
                          pause: const Duration(milliseconds: 100),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          FirebaseAuth.instance.currentUser?.email ?? 'Email',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[900],
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    buildAnimatedTile(
                      context,
                      Icons.warning,
                      'SoS',
                      Colors.amber,
                      const SoSPage(),
                    ),
                    buildAnimatedTile(
                      context,
                      Icons.local_hospital,
                      'Nearby Hospitals',
                      Colors.red,
                      const MapScreen(),
                    ),
                    buildAnimatedTile(
                      context,
                      Icons.chat,
                      'Swasthya Sakhi',
                      Colors.green,
                      const ChatScreen(),
                    ),
                    const SizedBox(height: 16),
                    buildSignOutButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedTile(BuildContext context, IconData icon, String title,
      Color iconColor, Widget page) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 200),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        tileColor: Colors.white,
      ),
    );
  }

  Widget buildSignOutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: const SignOutButton(),
    );
  }
}
