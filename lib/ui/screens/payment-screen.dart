import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  // https://github.com/flutter/flutter/issues/20042#issuecomment-459840969
  // if you remove the static field
  static final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment and vouchers"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: () async {}),
        ],
      ),
    );
  }
}
