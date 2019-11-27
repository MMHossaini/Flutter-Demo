import 'package:app/ui/screens/home.dart';
import 'package:app/utils/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool showLoading = false;

  @override
  void dispose() {
    firstNameInputController.dispose();
    lastNameInputController.dispose();

    passwordInputController.dispose();
    emailInputController.dispose();
    confirmPasswordInputController.dispose();

    super.dispose();
  }

  @override
  initState() {
    super.initState();
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
          key: registerForm,
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
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person)),
                    controller: firstNameInputController,
                    keyboardType: TextInputType.text,
                    validator: Validator.validateName,
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Last Name', prefixIcon: Icon(Icons.person)),
                    controller: lastNameInputController,
                    keyboardType: TextInputType.text,
                    validator: Validator.validateName,
                  )),
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
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Confirm password', prefixIcon: Icon(Icons.lock)),
                  controller: confirmPasswordInputController,
                  obscureText: true,
                  validator: Validator.validatePassword,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: new Text("Register"),
                    onPressed: createUserWithEmailAndPassword,
                  ),
                ),
              ),
              FlatButton(
                child: Text("Have an Account? Sign in"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    ));
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

          // createUserWithEmailAndPassword
          AuthResult result = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailInputController.text,
                  password: passwordInputController.text);

          // create user record
          await Firestore.instance
              .collection("users")
              .document(result.user.uid)
              .setData({
            "firstName": firstNameInputController.text,
            "lastName": lastNameInputController.text,
            "email": emailInputController.text,
          });

          setState(() {
            showLoading = true;
          });

          // take user to home
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        uid: result.user.uid,
                      )),
              (_) => false);
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
}
