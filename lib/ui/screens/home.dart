import 'package:app/main.dart';
import 'package:app/ui/screens/create-product.dart';
import 'package:app/ui/screens/my-orders.dart';
import 'package:app/ui/screens/profile.dart';
import 'package:app/ui/screens/settings.dart';
import 'package:app/ui/widgets/product-list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  FirebaseUser currentUser;
  @override
  initState() {
    super.initState();
    this.getCurrentUser();
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
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
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
                                builder: (context) => MyOrdersScreen()),
                          );
                        }),
                    new ListTile(
                        leading: Icon(Icons.power_settings_new),
                        title: new Text(
                          "Logout",
                          style: new TextStyle(
                              color: Colors.redAccent, fontSize: 17.0),
                        ),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          currentUser = null;
                          navigatorKey.currentState.pushNamedAndRemoveUntil(
                              '/login', (Route<dynamic> route) => false);
                        })
                  ],
                ),
              ),
              appBar: AppBar(
                title: Text("Flutter Demo"),
                centerTitle: true,
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
                  Center(
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(37.42796133580664, -122.085749655962),
                        zoom: 14.4746,
                      ),
                    ),
                  ),
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