import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';
import 'register.dart';
import 'splashscreen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Maz Market',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
        });
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
          title: Text('Enable Feature'),
          trailing: Checkbox(
            onChanged: (val) {},
            value: false,
          ),
          onTap: () {},
        )
      ]),
    );
  }
}

class ProductCreateOrEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
          title: Text('Enable Feature'),
          trailing: Checkbox(
            onChanged: (val) {},
            value: false,
          ),
          onTap: () {},
        )
      ]),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
          title: Text('Enable Feature'),
          trailing: Checkbox(
            onChanged: (val) {},
            value: false,
          ),
          onTap: () {},
        )
      ]),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
          title: Text('Enable Feature'),
          trailing: Checkbox(
            onChanged: (val) {},
            value: false,
          ),
          onTap: () {},
        )
      ]),
    );
  }
}

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
          title: Text('Enable Feature'),
          trailing: Checkbox(
            onChanged: (val) {},
            value: false,
          ),
          onTap: () {},
        )
      ]),
    );
  }
}

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
          title: Text('Enable Feature'),
          trailing: Checkbox(
            onChanged: (val) {},
            value: false,
          ),
          onTap: () {},
        )
      ]),
    );
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

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Detail"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Buy now'),
            onPressed: () {},
          ),
          FlatButton(
            child: Text('Add to cart'),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
