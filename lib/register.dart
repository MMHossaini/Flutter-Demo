import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> registerForm = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController firstNameInputController = TextEditingController();
  TextEditingController lastNameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController confirmPasswordInputController =
      TextEditingController();
  RegExp emailRegularExpression = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  bool showLoading = false;

  @override
  initState() {
    super.initState();
  }

/**
 * Checks if form is valid,
 * checks if both passwords match
 */
  createUserWithEmailAndPassword() async {
    try {
      // validate register form
      if (registerForm.currentState.validate()) {
        // check that both passwords match
        if (passwordInputController.text ==
            confirmPasswordInputController.text) {
          setState(() {
            showLoading = true;
          });

          // call firefabase
          AuthResult result = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailInputController.text,
                  password: passwordInputController.text);

          // create a user record
          if (result.user != null) {
            await Firestore.instance
                .collection("users")
                .document(result.user.uid)
                .setData({
              "firstName": firstNameInputController.text,
              "lastName": lastNameInputController.text,
              "email": emailInputController.text,
            });

            // take user to home
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          uid: result.user.uid,
                        )),
                (_) => false);
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("The passwords do not match"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          Flushbar(
                  title: "Email already registered",
                  message: emailInputController.text +
                      " Email is already registered",
                  duration: Duration(seconds: 3))
              .show(context);
          break;
        default:
          Flushbar(
                  title: "Error",
                  message: emailInputController.text +
                      "Something went wrong and we dont know what",
                  duration: Duration(seconds: 3))
              .show(context);
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
              key: registerForm,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'First Name'),
                    controller: firstNameInputController,
                    validator: (value) {
                      if (value.length < 3) {
                        return "Please enter a valid first name.";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Last Name'),
                      controller: lastNameInputController,
                      validator: (value) {
                        if (value.length < 3) {
                          return "Please enter a valid last name.";
                        } else {
                          return null;
                        }
                      }),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!emailRegularExpression.hasMatch(value)) {
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
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    controller: confirmPasswordInputController,
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
                    child: Text("Register"),
                    onPressed: createUserWithEmailAndPassword,
                  ),
                  Text("Already have an account?"),
                  FlatButton(
                    child: Text("Login here!"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )));
      }
    }

    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: getBody());
  }
}
