import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String documentId;
  final int quanity;
  final bool paid;
  final String notes;
  final String productId;
  final double totalCost;
  final String userId;

  Order(this.documentId, this.quanity, this.paid, this.notes, this.productId,
      this.totalCost, this.userId);

  Map<String, dynamic> toJson() => {
        'quanity': quanity,
        'paid': paid,
        'notes': notes,
        'productId': productId,
        'totalCost': totalCost,
        'userId': userId,
      };

  factory Order.fromDocument(DocumentSnapshot doc) {
    Order order = null;

    if (doc != null) {
      order = Order(doc.documentID, doc['quanity'], doc['paid'], doc['notes'],
          doc['productId'], doc['totalCost'], doc['userId']);
    }
    return order;
  }
}
