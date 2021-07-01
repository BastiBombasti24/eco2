import 'package:code/screens/authenticate/sign_in.dart';
import 'package:code/services/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'NavigationBottom.dart';

class MainWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: ChangeNotifierProvider(
            create: (context) => GoogleSignInProvider(),
            child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                final provider = Provider.of<GoogleSignInProvider>(context);

                if (provider.isSigningIn) {
                  return buildLoading();
                } else if (snapshot.hasData) {
                  return NavigationBottom();
                } else {
                  return SignUpWidget();
                }
              },
            ),
          ),
        ),
      );

  Widget buildLoading() => Center(child: CircularProgressIndicator());



  // Widget build(BuildContext context) {
  //
  //   final user = Provider.of<FirebaseUser>(context);
  //   print(user);
  //
  //   if (user != null) {
  //
  //   } else {
  //     return Scaffold(
  //       body: SignIn(),
  //     );
  //   }
  // }
}