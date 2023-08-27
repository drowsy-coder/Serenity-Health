import 'package:serenity/screens/home/home_page.dart';
import 'package:serenity/screens/home/main_page.dart';
import 'package:serenity/screens/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LoginMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String loggedInKey = 'loggedIn';

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Store login status
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(loggedInKey, true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(
            justLoggedIn: true,
          ),
        ),
      );

      return userCredential;
    } catch (e) {
      print(e.toString());
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text('Failed to sign in with Google.'),
        ),
      );
      rethrow;
    }
  }

  Future<void> checkLoggedIn(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? loggedIn = prefs.getBool(loggedInKey);

    if (loggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(loggedInKey, false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (e) {
      print(e.toString());
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text('Failed to sign out.'),
        ),
      );
      rethrow;
    }
  }
}
