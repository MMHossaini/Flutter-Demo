import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String documentId;
  final String title;
  final String fullDescription;
  final String shortDescription;

  final double cost;
  final List<String> pictures;

  Product(this.title, this.documentId, this.cost, this.fullDescription,
      this.shortDescription, this.pictures);

  factory Product.fromDocument(DocumentSnapshot doc) {
    Product product = null;

    if (doc != null) {
      product = new Product(
          doc['title'],
          doc.documentID,
          doc['cost'].toDouble(),
          doc['fullDescription'],
          doc['shortDescription'],
          doc['pictures'].cast<String>());
    }
    return product;
  }
}
