import 'package:app/main.dart';
import 'package:app/models/order-model.dart';
import 'package:app/models/product-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key key, this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(product.title),
        ),
        body: Column(
          children: <Widget>[
            Hero(
              child: Image.network(
                product.pictures[0],
                fit: BoxFit.cover,
              ),
              tag: 'dash' + product.documentId,
            ),
            Text(product.fullDescription),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Buy'),
          icon: Icon(Icons.shopping_cart),
          onPressed: () async {
            // create a new order
            Order newOrder = Order(null, 69, false, "test order",
                product.documentId, product.cost * 45, currentUser.uid);
            DocumentReference ref = await Firestore.instance
                .collection('orders')
                .add(newOrder.toJson());
          },
        ));
  }
}
