import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Text('Please check your email and verify your account'),
        SizedBox(
          width: double.maxFinite,
          child: RaisedButton(
              child: new Text("Send email again"),
              onPressed: () async {
                var currentUser = await FirebaseAuth.instance.currentUser();
                await currentUser.sendEmailVerification();

                // show message that email has been sent
              }),
        )
      ],
    ));
  }
}
