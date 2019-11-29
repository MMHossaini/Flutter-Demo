import 'package:app/models/product-model.dart';
import 'package:app/ui/screens/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('products').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                Product product = Product.fromDocument(document);
                return Card(
                  child: ListTile(
                    leading: ClipRect(
                      child: Image.network(
                        product.pictures[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    trailing: Text(r"$" + product.cost.toString()),
                    title: Text(product.title),
                    subtitle: Text(product.shortDescription),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
