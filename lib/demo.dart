// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class Products extends StatelessWidget {
//   final TextEditingController _textEditingControllerTitle =
//       TextEditingController();
//
//   final TextEditingController _textEditingControllerDesc =
//       TextEditingController();
//
//   final TextEditingController _textEditingControllerPrice =
//       TextEditingController();
//
//   var productRef = FirebaseFirestore.instance.collection('products');
//
//   File? imageFile;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Center(
//               child: Text(
//             "Product",
//             style: TextStyle(fontSize: 25),
//           )),
//           backgroundColor: Colors.amber),
//       body: StreamBuilder(
//         stream: getProducts(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Something went wrong'));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CupertinoActivityIndicator());
//           }
//
//           return ListView.separated(
//             itemCount: snapshot.data!.docs.length,
//             scrollDirection: Axis.vertical,
//             itemBuilder: (context, index) {
//               Map<String, dynamic> product =
//                   snapshot.data?.docs[index].data() as Map<String, dynamic>;
//
//               return ListTile(
//                 leading: Material(
//                   shape: ContinuousRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   clipBehavior: Clip.antiAlias,
//                   elevation: 5,
//                   child: SizedBox(
//                       width: 60,
//                       child: Image.network(
//                         "${product['image']}",
//                         errorBuilder: (context, error, stackTrace) {
//                           return Image.asset(
//                             'assets/images/img.jpg',
//                             fit: BoxFit.cover,
//                           );
//                         },
//                         fit: BoxFit.cover,
//                       )),
//                 ),
//                 title: Text(
//                   "${product['title']}",
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("${product['description']}",
//                         overflow: TextOverflow.ellipsis),
//                     Text(
//                       " Price: \u20B9 ${product['price']}",
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//                 trailing: Row(mainAxisSize: MainAxisSize.min, children: [
//                   IconButton(
//                     onPressed: () {
//                       updateProduct(
//                           context, snapshot.data!.docs[index].id, product);
//                     },
//                     icon: Icon(Icons.edit),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       removeProducts(
//                           snapshot.data!.docs[index].id, product['image']);
//                     },
//                     icon: Icon(Icons.delete),
//                   ),
//                 ]),
//               );
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return Divider(
//                 indent: 20,
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           addProduct(context);
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.amber,
//       ),
//     );
//   }
//
//   void addProduct(BuildContext context) async {
//     imageFile = null;
//
//     await showDialog(
//       barrierDismissible: true,
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               insetPadding: EdgeInsets.all(12),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         Container(
//                           height: 100,
//                           width: 100,
//                           clipBehavior: Clip.antiAlias,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.grey,
//                           ),
//                           child: imageFile != null
//                               ? Image.file(
//                                   imageFile!,
//                                   fit: BoxFit.cover,
//                                 )
//                               : SizedBox(),
//                         ),
//                         IconButton(
//                             onPressed: () async {
//                               XFile? imageFile = await ImagePicker()
//                                   .pickImage(source: ImageSource.gallery);
//
//                               setState(() {
//                                 this.imageFile = File(imageFile!.path);
//                               });
//                             },
//                             icon: Icon(
//                               Icons.camera_alt_outlined,
//                               color: Colors.white,
//                             ))
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextField(
//                       controller: _textEditingControllerTitle,
//                       decoration: InputDecoration(
//                           hintText: "Product Name",
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12))),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextField(
//                       controller: _textEditingControllerDesc,
//                       decoration: InputDecoration(
//                           hintText: "Product Description",
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12))),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextField(
//                       controller: _textEditingControllerPrice,
//                       decoration: InputDecoration(
//                           hintText: "Product Price",
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12))),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     MaterialButton(
//                       height: 50,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       onPressed: () async {
//                         if (imageFile != null &&
//                             _textEditingControllerTitle.text != "" &&
//                             _textEditingControllerDesc.text != "" &&
//                             _textEditingControllerPrice.text != "") {
//                           String imageUrl = await uploadImage();
//
//                           Map<String, dynamic> newProduct = {
//                             "image": imageUrl,
//                             "title": _textEditingControllerTitle.text,
//                             "description": _textEditingControllerDesc.text,
//                             "price": _textEditingControllerPrice.text,
//                           };
//                           productRef.add(newProduct).then((value) {
//                             Navigator.pop(context);
//                           });
//                         }
//                       },
//                       color: Colors.amber,
//                       child: Text("Add Product"),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//
//     print("hii");
//     _textEditingControllerPrice.clear();
//     _textEditingControllerDesc.clear();
//     _textEditingControllerTitle.clear();
//   }
//
//   void updateProduct(
//       BuildContext context, String? id, Map<String, dynamic> products) async {
//     _textEditingControllerTitle.text = products['title'];
//     _textEditingControllerDesc.text = products['description'];
//     _textEditingControllerPrice.text = products['price'];
//     var oldImage = products['image'];
//
//     await showDialog(
//       barrierDismissible: true,
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               insetPadding: EdgeInsets.all(12),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         Container(
//                           height: 100,
//                           width: 100,
//                           clipBehavior: Clip.antiAlias,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.grey,
//                           ),
//                           child: imageFile != null
//                               ? Image.file(
//                                   imageFile!,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Image.network(
//                                   oldImage,
//                                   fit: BoxFit.cover,
//                                 ),
//                         ),
//                         IconButton(
//                             onPressed: () async {
//                               XFile? imageFile = await ImagePicker()
//                                   .pickImage(source: ImageSource.gallery);
//
//                               setState(() {
//                                 this.imageFile = File(imageFile!.path);
//                               });
//                             },
//                             icon: Icon(
//                               Icons.camera_alt_outlined,
//                               color: Colors.white,
//                             ))
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextField(
//                       controller: _textEditingControllerTitle,
//                       decoration: InputDecoration(
//                           hintText: "Product Name",
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12))),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextField(
//                       controller: _textEditingControllerDesc,
//                       decoration: InputDecoration(
//                           hintText: "Product Description",
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12))),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextField(
//                       controller: _textEditingControllerPrice,
//                       decoration: InputDecoration(
//                           hintText: "Product Price",
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12))),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     MaterialButton(
//                       height: 50,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       onPressed: () async {
//                         if (_textEditingControllerTitle.text != "" &&
//                             _textEditingControllerDesc.text != "" &&
//                             _textEditingControllerPrice.text != "") {
//                           if (imageFile != null) {
//                             print("with image update case");
//
//                             String imageUrl = await uploadImage();
//                             Map<String, dynamic> newProduct = {
//                               "image": imageUrl,
//                               "title": _textEditingControllerTitle.text,
//                               "description": _textEditingControllerDesc.text,
//                               "price": _textEditingControllerPrice.text,
//                             };
//
//                             FirebaseStorage.instance
//                                 .refFromURL(oldImage)
//                                 .delete()
//                                 .then((value) {
//                               productRef
//                                   .doc(id)
//                                   .update(newProduct)
//                                   .then((value) {
//                                 Navigator.pop(context);
//                               });
//                             });
//                           } else {
//                             print("without image update case");
//
//                             Map<String, dynamic> newProduct = {
//                               "title": _textEditingControllerTitle.text,
//                               "description": _textEditingControllerDesc.text,
//                               "price": _textEditingControllerPrice.text,
//                             };
//
//                             productRef.doc(id).update(newProduct).then((value) {
//                               Navigator.pop(context);
//                             });
//                           }
//                         }
//                       },
//                       color: Colors.amber,
//                       child: Text("Update"),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//
//     print("hii");
//     _textEditingControllerPrice.clear();
//     _textEditingControllerDesc.clear();
//     _textEditingControllerTitle.clear();
//   }
//
//   Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
//     return FirebaseFirestore.instance.collection('products').snapshots();
//   }
//
//   void removeProducts(String id, String imgUrl) {
//     FirebaseStorage.instance.refFromURL(imgUrl).delete().then((value) {
//       productRef.doc(id).delete().then((value) {
//         print("deleted");
//       });
//     });
//   }
//
//   Future<String> uploadImage() async {
//     final storageRef = FirebaseStorage.instance.ref();
//     final productsImgRef = storageRef.child(
//         "products/${(DateTime.timestamp().year + DateTime.timestamp().month + DateTime.timestamp().day + DateTime.timestamp().hour + DateTime.timestamp().minute + DateTime.timestamp().second + DateTime.timestamp().millisecond + DateTime.timestamp().microsecond)}${imageFile!.path.split("/").last}");
//
//     try {
//       var uploadTask = await productsImgRef.putFile(imageFile!);
//
//       String url = await uploadTask.ref.getDownloadURL();
//       return url;
//     } catch (e) {
//       print(e);
//       return "";
//     }
//   }
// }
