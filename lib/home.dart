import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'create-product.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.uid}) : super(key: key);

  final String title;
  final String uid;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  FirebaseUser currentUser;
  @override
  initState() {
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var userDocument = snapshot.data;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: new Text(userDocument["firstName"] +
                          " " +
                          userDocument["lastName"]),
                      accountEmail: new Text(userDocument["email"]),
                      onDetailsPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      },
                      currentAccountPicture: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://www.fakenamegenerator.com/images/sil-female.png")),
                    ),
                    new ListTile(
                        leading: Icon(Icons.settings),
                        title: new Text("Setting"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()),
                          );
                        }),
                    new ListTile(
                        leading: Icon(Icons.help),
                        title: new Text("Help"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                          );
                        }),
                    new ListTile(
                        leading: Icon(Icons.history),
                        title: new Text("Order History "),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderHistoryPage()),
                          );
                        }),
                    new ListTile(
                        leading: Icon(Icons.power_settings_new),
                        title: new Text(
                          "Logout",
                          style: new TextStyle(
                              color: Colors.redAccent, fontSize: 17.0),
                        ),
                        onTap: () {
                          FirebaseAuth.instance
                              .signOut()
                              .then((result) => Navigator.pushReplacementNamed(
                                  context, "/login"))
                              .catchError((err) => print(err));
                        })
                  ],
                ),
              ),
              appBar: AppBar(
                title: Text(widget.title),
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'List'),
                    Tab(
                      text: 'Map',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  ProductsList(),
                  Icon(Icons.map),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                label: Text('Create Product'),
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateProductPage()),
                  );
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            ), //
          );
        });
  }
}
