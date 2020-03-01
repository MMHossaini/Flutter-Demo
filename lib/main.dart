import 'package:app/ui/screens/error-screen.dart';
import 'package:app/ui/screens/home.dart';
import 'package:app/ui/screens/payment-screen.dart';
import 'package:app/ui/screens/walk-through-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ui/screens/forgot-password.dart';
import 'ui/screens/login.dart';
import 'ui/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Some notes on how we handle authentication ============
// we use a key,
// the first time a user comes into the app, we show the walk through page
// when they click get started on the walk through page we set the key to true
// so next time they load the app, we take them straight to the welcome page
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
FirebaseUser currentUser;
SharedPreferences preferences;
Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  currentUser = await FirebaseAuth.instance.currentUser();
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,        
        builder: (BuildContext context, Widget widget) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return ErrorScreen(
              errorDetails: errorDetails,
            );
          };

          return widget;
        },
        home: getFirstScreen(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/forgot-password': (BuildContext context) => ForgotPasswordPage(),
          '/payment': (BuildContext context) => PaymentScreen(),
        });
  }

  Widget getFirstScreen() {
    // if user is loggedIn take them to home
    if (currentUser != null) {
      return new HomePage(
        uid: currentUser.uid,
      );
    } else {
      bool seen = (preferences.getBool('seen') ?? false);
      if (seen) {
        return new LoginPage();
      } else {
        return new WalkThroughPage();
      }
    }
  }
}
