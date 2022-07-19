// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_new

import 'package:flutter/material.dart';

class InfoBRT extends StatelessWidget {
  const InfoBRT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[700],
          title: Text("Informasi Angkutan"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    new Image(image: AssetImage("images/Logo.png")),
                    Text(
                      "Informasi Angkutan",
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
