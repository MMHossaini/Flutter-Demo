import 'package:app/ui/screens/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'create-account-page.dart';
import 'ui/screens/forgot-password.dart';
import 'ui/screens/login.dart';
import 'ui/screens/register.dart';
import 'walk-through-page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Some notes on how we handle authentication ============
// we use a key,
// the first time a user comes into the app, we show the walk through page
// when they click get started on the walk through page we set the key to true
// so next time they load the app, we take them straight to the welcome page
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
SharedPreferences preferences;
Future<Null> main() async {
  preferences = await SharedPreferences.getInstance();
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: getFirstScreen(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/forgot-password': (BuildContext context) => ForgotPasswordPage(),
          '/create-account': (BuildContext context) => CreateAccountPage(),
        });
  }

  Widget getFirstScreen() {
    bool seen = (preferences.getBool('seen') ?? false);
    if (seen) {
      return new LoginPage();
    } else {
      return new WalkThroughPage();
    }
  }
}

class ProductsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('products').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
              child: new CircularProgressIndicator(),
            );
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['title']),
                  subtitle: new Text(document['description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetailPage()),
                    );
                  },
                );
              }).toList(),
            );
        }
      },
    );
  }
}
