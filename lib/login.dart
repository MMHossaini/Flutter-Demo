import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  bool showLoading = false;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /// Checks if the login form is valid
  /// updates state to show loading
  /// calls firebase to authenticate
  /// if successful, navaigates to home
  signInWithEmailAndPassword() async {
    try {
      // check that the form is valid
      if (loginForm.currentState.validate()) {
        setState(() {
          // show loading
          showLoading = true;
        });
        // login
        AuthResult result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailInputController.text,
                password: passwordInputController.text);

        // take user to home if logged in
        if (result.user != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        title: "Apps Factory",
                        uid: result.user.uid,
                      )));
        }
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_USER_NOT_FOUND':
          // user is not found , maybe they should register
          break;

        case 'ERROR_WRONG_PASSWORD':
          // wrong password
          break;

        default:
        // show something went wrong
      }
      setState(() {
        // show loading
        showLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getBody() {
      if (showLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: SingleChildScrollView(
                child: Form(
              key: loginForm,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!regex.hasMatch(value)) {
                        return 'Email format is invalid';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: passwordInputController,
                    obscureText: true,
                    validator: (value) {
                      if (value.length < 8) {
                        return 'Password must be longer than 8 characters';
                      } else {
                        return null;
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text("Login"),
                    onPressed: signInWithEmailAndPassword,
                  ),
                  Text("Don't have an account yet?"),
                  FlatButton(
                    child: Text("Register here!"),
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                  )
                ],
              ),
            )));
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: getBody());
  }
}
