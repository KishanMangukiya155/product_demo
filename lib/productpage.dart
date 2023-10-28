import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_demo/demo.dart';

class ProductPage extends StatelessWidget {
  final TextEditingController _textEditingControllerTitle =
      TextEditingController();
  final TextEditingController _textEditingControllerDes =
      TextEditingController();
  final TextEditingController _textEditingControllerPrice =
      TextEditingController();

  var productReference = FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
              child: Text(
            "Product App",
            style: TextStyle(fontSize: 25, color: Colors.white),
          )),
          backgroundColor: Color(0xffffd792d)),
      body: StreamBuilder(
          stream: getProductsData(),
          builder: (context, snapshot) {
            print(snapshot.data?.docs.length);
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CupertinoActivityIndicator(
                animating: true,
                radius: 30,
                color: Colors.black,
              ));
            }
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Map<String, dynamic> productList =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>;
                return ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff94bbe9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    //height: 80,
                    width: 60,
                  ),
                  title: Text(
                    "${productList['title']}",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${productList['description']}"),
                      Text(
                        "Price: \u20B9 ${productList['price']}",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  trailing: FittedBox(
                      fit: BoxFit.fill,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              removeProduct(
                                  snapshot.data!.docs[index].id, productList);
                            },
                            icon: Icon(Icons.delete, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () {
                              updateProduct(context,
                                  snapshot.data!.docs[index].id, productList);
                            },
                            icon: Icon(Icons.edit, color: Colors.black),
                          ),
                        ],
                      )),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  indent: 5,
                  color: Colors.grey,
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addProducts(context);
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xfffd792d),
      ),
    );
  }

  void addProducts(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            clipBehavior: Clip.none,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                                colors: [Colors.teal, Colors.cyan]),
                          ),
                          child: CupertinoButton(
                            onPressed: () async {
                              await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                            },
                            child: Icon(Icons.camera_alt_outlined,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _textEditingControllerTitle,
                          decoration: InputDecoration(
                              hintText: "Product Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _textEditingControllerDes,
                          decoration: InputDecoration(
                              hintText: "Product Description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _textEditingControllerPrice,
                          decoration: InputDecoration(
                              hintText: "Product Price",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          height: 40,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: () {
                            if (_textEditingControllerTitle.text != "" &&
                                _textEditingControllerDes.text != "" &&
                                _textEditingControllerPrice.text != "") {
                              // Navigator.pop(context);
                              Map<String, dynamic> newProduct = {
                                "title": _textEditingControllerTitle.text,
                                "description": _textEditingControllerDes.text,
                                "price": _textEditingControllerPrice.text,
                              };
                              print("show");
                              productReference.add(newProduct).then((value) {
                                Navigator.pop(context);
                              });
                            }
                          },
                          color: Colors.blueAccent,
                          child: Text("Add Product",
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
    print("product clear");
    _textEditingControllerPrice.clear();
    _textEditingControllerDes.clear();
    _textEditingControllerTitle.clear();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsData() {
    return FirebaseFirestore.instance.collection('Products').snapshots();
  }

  void removeProduct(String id, Map<String, dynamic> products) {
    FirebaseFirestore.instance.collection("Products");
    productReference.doc(id).delete().then((value) {
      print("Deleted");
    });
  }

  void updateProduct(
      BuildContext context, String id, Map<String, dynamic> products) async {
    _textEditingControllerTitle.text = products["title"];
    _textEditingControllerDes.text = products['description'];
    _textEditingControllerPrice.text = products['price'];

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            clipBehavior: Clip.none,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                  colors: [Colors.teal, Colors.cyan])),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _textEditingControllerTitle,
                          decoration: InputDecoration(
                              hintText: "Product Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _textEditingControllerDes,
                          decoration: InputDecoration(
                              hintText: "Product Description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _textEditingControllerPrice,
                          decoration: InputDecoration(
                              hintText: "Product Price",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          height: 40,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: () {
                            if (_textEditingControllerTitle.text != "" &&
                                _textEditingControllerDes.text != "" &&
                                _textEditingControllerPrice.text != "") {
                              // Navigator.pop(context);
                              Map<String, dynamic> newProduct = {
                                "title": _textEditingControllerTitle.text,
                                "description": _textEditingControllerDes.text,
                                "price": _textEditingControllerPrice.text,
                              };
                              _textEditingControllerTitle.clear();
                              _textEditingControllerPrice.clear();
                              _textEditingControllerDes.clear();
                              print("Update");
                              productReference
                                  .doc(id)
                                  .update(newProduct)
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            }
                          },
                          color: Colors.blueAccent,
                          child: Text("Update",
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
