// ignore_for_file: annotate_overrides, avoid_unnecessary_containers, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:trans_mamminasata/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    splashscreenStart();
  }

  splashscreenStart() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Container(
        // ignore: prefer_const_constructors
        child: Center(child: Image(image: AssetImage("images/Pencarian rute.png"))),
      ),
    );
  }
}
