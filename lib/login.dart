import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'userRepository.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    // show progress if user is authentication
    if (user.status == Status.Authenticating) {
      return Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }

    // show login plage
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Form(
          key: loginForm,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Email', prefixIcon: Icon(Icons.email)),
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
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Password', prefixIcon: Icon(Icons.lock)),
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
              ),
              RaisedButton(
                child: Text("Login"),
                onPressed: () async {
                  if (loginForm.currentState.validate()) {
                    try {
                      await user.signIn(emailInputController.text,
                          passwordInputController.text);
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
                    }
                  }
                },
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
        ),
      ),
    ));
  }
}
