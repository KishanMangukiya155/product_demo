import 'dart:async';

import 'package:flutter/material.dart';
import 'package:product_demo/productpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => ProductPage()));
    });
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: 364,
        color: Color(0xfffd792d),
        child: Center(
            child: Icon(
          Icons.production_quantity_limits,
          size: 100,
          color: Colors.white,
        )),
      ),
    );
  }
}
