import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const ErrorScreen({Key key, this.errorDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Error appeared.",
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(height: 10),
          Text(
            "But its all good cause we now know and and will fix it asap cause Mustafa is the man",
          ),
          SizedBox(height: 20),
          Text(
            "Details.",
            style: Theme.of(context).textTheme.subtitle,
          ),
          SizedBox(height: 10),
          Text(errorDetails.exceptionAsString())
        ],
      ),
    )));
  }
}
