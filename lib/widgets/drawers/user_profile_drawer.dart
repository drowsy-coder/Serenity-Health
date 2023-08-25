import 'package:serenity/screens/Sakhi/chat_screen.dart';
import 'package:serenity/screens/SoS/sos_location.dart';
import 'package:serenity/widgets/buttons/sign_out_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    FirebaseAuth.instance.currentUser?.displayName ??
                        'Username',
                    textStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 100),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? 'Email',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser?.photoURL ?? '',
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : const Color(0xFFAEC6CF),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[980],
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    DelayedDisplay(
                      delay: const Duration(milliseconds: 200),
                      child: ListTile(
                        leading: const Icon(
                          Icons.warning,
                          color: Colors.amber,
                        ),
                        title: const Text(
                          'SoS',
                          style: TextStyle(
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
                            MaterialPageRoute(builder: (context) => SoSPage()),
                          );
                        },
                        tileColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors.white,
                      ),
                    ),
                    DelayedDisplay(
                      delay: const Duration(milliseconds: 300),
                      child: ListTile(
                        leading: const Icon(
                          Icons.chat,
                          color: Colors.green,
                        ),
                        title: const Text(
                          'Swasthya Sakhi',
                          style: TextStyle(
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
                            MaterialPageRoute(
                                builder: (context) => const ChatScreen()),
                          );
                        },
                        tileColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    const SignOutButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
