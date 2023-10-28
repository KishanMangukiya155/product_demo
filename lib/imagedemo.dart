import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Imagedemo extends StatefulWidget {
  const Imagedemo({super.key});

  @override
  State<Imagedemo> createState() => _ImagedemoState();
}

class _ImagedemoState extends State<Imagedemo> {
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Center(
              child: Text(
            "Image",
            style: TextStyle(color: Colors.white),
          ))),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(children: [
            Container(
              clipBehavior: Clip.antiAlias,
              height: 550,
              width: 364,
              child: imageFile == null
                  ? SizedBox()
                  : Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () async {
                  XFile? xFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  setState(() {
                    imageFile = File(xFile!.path);
                  });
                },
                child: Text("Select Image")),
            SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  imageFile == null ? null : uploadImage();
                },
                child: Text("Upload Image")),
          ]),
        ),
      ),
    );
  }

  void uploadImage() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child(
            '/kishan file/${DateTime.now()}+${imageFile?.path.split("/").last}')
        .putFile(imageFile!);

    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    print(url);
  }
}
