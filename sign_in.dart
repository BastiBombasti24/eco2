import 'package:flutter/material.dart';

import 'google_signup_button_widget.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      buildSignUp(),
    ],
  );

  Widget buildSignUp() => Column(
    children: [
      Spacer(),
      Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: 175,
          child: Image.asset('assets/images/Logo.png'),
        ),
      ),
      Spacer(),
      GoogleSignupButtonWidget(),
      SizedBox(height: 12),
      Text(
        'Zum Fortfahren einloggen',
        style: TextStyle(fontSize: 16),
      ),
      Spacer(),
    ],
  );
}