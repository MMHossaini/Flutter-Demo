import 'package:app/main.dart';
import 'package:app/utils/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart';

import 'package:app/models/user-model.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();

  Future<User> getUserRecord(String userId) async {
    var document =
        Firestore.instance.collection("users").document(userId).get();
    return await document.then((doc) {
      return User.fromDocument(doc);
    });
  }
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  var showLoading;

  @override
  void initState() {
    super.initState();
    showLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (this.showLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // show login plage
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Form(
          key: loginForm,
          child: Column(
            children: <Widget>[
              Icon(
                Icons.person,
                size: 200,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email', prefixIcon: Icon(Icons.email)),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validator.validateEmail,
                  )),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                  controller: passwordInputController,
                  obscureText: true,
                  validator: Validator.validatePassword,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: new Text("Sign in"),
                    onPressed: () async {
                      if (loginForm.currentState.validate()) {
                        try {
                          setState(() {
                            showLoading = true;
                          });

                          AuthResult result = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: passwordInputController.text);

                          currentUser = result.user;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        uid: result.user.uid,
                                      )),
                              (_) => false);

                          setState(() {
                            showLoading = false;
                          });

                          Flushbar(
                                  title: "Welcome back",
                                  message: "You are safe here",
                                  duration: Duration(seconds: 3))
                              .show(context);
                        } on PlatformException catch (e) {
                          switch (e.code) {
                            case 'ERROR_USER_NOT_FOUND':
                              Flushbar(
                                      title: "User not found",
                                      message: emailInputController.text +
                                          " is not a registered email",
                                      duration: Duration(seconds: 3))
                                  .show(context);
                              break;

                            case 'ERROR_WRONG_PASSWORD':
                              Flushbar(
                                      title: "Wrong Password",
                                      message: "Reset Password coming soon",
                                      duration: Duration(seconds: 3))
                                  .show(context);
                              break;

                            case 'ERROR_TOO_MANY_REQUESTS':
                              // too many failed attempts
                              // we can include a recaptacha
                              Flushbar(
                                      title: "Too many tries!",
                                      message: "Give it a minit will ya!",
                                      duration: Duration(seconds: 3))
                                  .show(context);
                              break;

                            default:
                              Flushbar(
                                      title: "Something else",
                                      message:
                                          "Something else went wrong and ye aint event know it",
                                      duration: Duration(seconds: 3))
                                  .show(context);
                          }

                          setState(() {
                            showLoading = false;
                          });
                        }
                      }
                    },
                  ),
                ),
              ),
              FlatButton(
                child: Text("Forgot password?"),
                onPressed: () {
                  Navigator.pushNamed(context, "/forgot-password");
                },
              ),
              FlatButton(
                child: Text("Craete Account"),
                onPressed: () {
                  Navigator.pushNamed(context, "/register");
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
