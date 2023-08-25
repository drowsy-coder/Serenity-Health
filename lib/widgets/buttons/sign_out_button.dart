import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:serenity/screens/login/login_method.dart';

class SignOutButton extends StatefulWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  State<SignOutButton> createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
  final LoginMethods _loginMethods = LoginMethods();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          text: 'Do you want to logout?',
          confirmBtnText: 'No',
          cancelBtnText: 'Yes',
          confirmBtnColor: Colors.red,
          backgroundColor: Colors.black,
          customAsset: 'assets/images/logout.png',
          confirmBtnTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          titleColor: Colors.white,
          textColor: Colors.white,
          onConfirmBtnTap: () {
            _loginMethods.signOut(context);
            Navigator.pop(context); // Close the QuickAlert
          },
        );
      },
      child: const Text('Log Out'),
    );
  }
}
