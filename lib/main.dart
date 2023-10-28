import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:product_demo/productpage.dart';
import 'package:product_demo/splashscreen.dart';
import 'package:product_demo/std.dart';

import 'imagedemo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Imagedemo(),
    );
  }
}
