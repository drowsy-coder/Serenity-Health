import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import flutter package for HapticFeedback
import 'package:neopop/neopop.dart'; // Import NeoPop library
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
    return NeoPopTiltedButton(
      isFloating: true,
      onTapUp: () {
        // Add haptic feedback on tap
        HapticFeedback.mediumImpact();

        QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          text: 'Do you want to logout?',
          confirmBtnText: 'Yes',
          cancelBtnText: 'No',
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
      decoration: const NeoPopTiltedButtonDecoration(
        color: Color.fromRGBO(255, 52, 52, 1),
        plunkColor: Color.fromRGBO(228, 62, 62, 1),
        shadowColor: Color.fromRGBO(36, 36, 36, 1),
        showShimmer: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0), // Adjust padding for size
        child: Center(
          child: Text(
            'Log Out',
            style: TextStyle(
              color: Colors.black, // Adjust text color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
