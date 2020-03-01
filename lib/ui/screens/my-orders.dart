import 'package:app/main.dart';
import 'package:app/models/order-model.dart';
import 'package:app/models/product-model.dart';
import 'package:app/ui/screens/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('orders')
          .where('userId', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            return Scaffold(
              appBar: AppBar(
                title: Text('My orders'),
              ),
              body: ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  Order order = Order.fromDocument(document);
                  return ListTile(
                    trailing: Text(order.totalCost.toString()),
                    title: Text(order.notes),
                    subtitle: Text(order.productId),
                    onTap: () {},
                  );
                }).toList(),
              ),
            );
        }
      },
    );
  }
}
