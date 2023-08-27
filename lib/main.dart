import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:serenity/screens/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final LocalAuthentication auth = LocalAuthentication();
  bool authenticated = false;

  try {
    authenticated = await auth.authenticate(
      localizedReason: 'Scan your fingerprint to authenticate',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
  } catch (e) {
    print("Fingerprint authentication error: $e");
  }

  if (authenticated) {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: LoginPage(),
    );
  }
}