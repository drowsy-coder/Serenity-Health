import 'package:serenity/screens/login/login_method.dart';
import 'package:flutter/material.dart';


class CustomSignInButton extends StatelessWidget {
  final LoginMethods loginMethods = LoginMethods();
  final VoidCallback onPressed;

  CustomSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google.gif',
              height: 30.0,
              width: 30.0,
            ),
            const SizedBox(width: 8.0),
            const Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
