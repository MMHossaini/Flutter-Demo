import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> emailForm = GlobalKey<FormState>();
  String _email;
  bool _showLoading = false;
  @override
  Widget build(BuildContext context) {
    // show progress if user is authentication
    if (_showLoading) {
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
          key: emailForm,
          child: Column(
            children: <Widget>[
              Icon(
                Icons.person,
                size: 200,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  onSaved: (value) => _email = value,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text("Send Me Password Reset Email"),
                    onPressed: () async {
                      if (emailForm.currentState.validate()) {
                        try {
                          emailForm.currentState.save();
                          setState(() {
                            _showLoading = true;
                          });
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: _email);

                          Flushbar(
                                  title: "Email sent",
                                  message:
                                      "Check your email for password reset instructions",
                                  duration: Duration(seconds: 3))
                              .show(context);
                          setState(() {
                            _showLoading = false;
                          });
                        } on PlatformException catch (e) {
                          switch (e.code) {
                            case 'ERROR_INVALID_EMAIL ':
                              Flushbar(
                                      title: "Invalid email",
                                      message:
                                          "Computer says that dont like an email address to me",
                                      duration: Duration(seconds: 3))
                                  .show(context);
                              break;

                            case 'ERROR_USER_NOT_FOUND ':
                              Flushbar(
                                      title: "Not Registered",
                                      message:
                                          "That email address is not registered with us brah",
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
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
