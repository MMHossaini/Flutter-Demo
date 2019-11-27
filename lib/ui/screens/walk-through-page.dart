import 'package:app/main.dart';
import 'package:app/models/walk-through-model.dart';
import 'package:flutter/material.dart';
import "package:flutter_swiper/flutter_swiper.dart";

class WalkThroughPage extends StatefulWidget {
  final List<WalkThrough> pages = [
    WalkThrough(
      icon: Icons.developer_mode,
      title: "Welcome",
      backgroundColor: Colors.green,
      description:
          "Source code is available on github, please like the project on github",
    ),
    WalkThrough(
      icon: Icons.help,
      backgroundColor: Colors.red,
      title: "Go up on your price",
      description: "Learn Flutter and go up on your development price",
    ),
    WalkThrough(
      backgroundColor: Colors.black87,
      extraWidget: Column(
        children: <Widget>[
          SizedBox(
            width: double.maxFinite,
            child: RaisedButton(
              child: new Text("Get Started"),
              onPressed: () {
                preferences.setBool('seen', true);
                navigatorKey.currentState.pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
            ),
          ),
        ],
      ),
      icon: Icons.web,
      title: "Get Started",
      description:
          "Firebase authentication is used here, safe and secure buddy buddy",
    ),
  ];

  @override
  WalkThroughPageState createState() => WalkThroughPageState();
}

class WalkThroughPageState extends State<WalkThroughPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper(
        itemCount: 3,
        pagination: SwiperPagination(),
        itemBuilder: (BuildContext context, int index) {
          WalkThrough page = widget.pages[index];
          return Container(
            color: page.backgroundColor,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Icon(
                    page.icon,
                    size: 125.0,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                  child: Text(
                    page.title,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    page.description,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: page.extraWidget,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
