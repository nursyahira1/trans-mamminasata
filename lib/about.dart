// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_new

import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[700],
          title: Text("TENTANG"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    new Image(image: AssetImage("images/Logo.png")),
                    Text(
                      "Tentang",
                      style: TextStyle(fontSize: 20.0),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
