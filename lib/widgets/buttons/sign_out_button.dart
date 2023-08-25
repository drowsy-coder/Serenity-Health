import 'package:serenity/screens/login/login_method.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginMethods _loginMethods = LoginMethods();
    
    return ElevatedButton(
      onPressed: () {
        _loginMethods.signOut(context);
      },
      child: const Text('Log Out'),
    );
  }
}