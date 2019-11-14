import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateProductPage extends StatefulWidget {
  CreateProductPage({Key key, this.title, this.uid})
      : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  CreateProductPageState createState() => CreateProductPageState();
}

class CreateProductPageState extends State<CreateProductPage> {
  final GlobalKey<FormState> newProductForm = GlobalKey<FormState>();

  TextEditingController productTitleInputController;
  TextEditingController productDescripInputController;
  FirebaseUser currentUser;

  @override
  initState() {
    productTitleInputController = new TextEditingController();
    productDescripInputController = new TextEditingController();
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Item"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (newProductForm.currentState.validate()) {
                Firestore.instance
                    .collection("products")
                    .add({
                      "title": productTitleInputController.text,
                      "description": productDescripInputController.text
                    })
                    .then((result) => {
                          Navigator.pop(context),
                        })
                    .catchError((err) => print(err));
              }
            },
            icon: Icon(Icons.done),
          )
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: newProductForm,
            child: Column(
              children: <Widget>[
                Text("Please fill all fields to create a new item for sell"),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Item Title*'),
                  controller: productTitleInputController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Item Description*'),
                  controller: productDescripInputController,
                )
              ],
            ),
          )),
    );
  }
}
