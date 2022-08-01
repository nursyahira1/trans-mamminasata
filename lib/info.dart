// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_new

import 'package:flutter/material.dart';
import 'package:trans_mamminasata/New folder/biaya.dart';
import 'package:trans_mamminasata/New%20folder/halte1.dart';
import 'package:trans_mamminasata/New folder/jam_operasional.dart';
import 'package:trans_mamminasata/New folder/kapasitas.dart';
import 'package:trans_mamminasata/New folder/unit.dart';

class InfoBRT extends StatelessWidget {
  const InfoBRT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[700],
          title: Text("Informasi Angkutan"),
          actions: [
            PopupMenuButton<MenuItem>(
                icon: Icon(Icons.menu),
                onSelected: ((item) => onSelected(context, item)),
                itemBuilder: (context) =>
                    [...MenuItems.itemFirst.map(buildItem).toList()])
          ],
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

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, color: Colors.black, size: 20),
            const SizedBox(width: 12),
            Text(item.text),
          ],
        ),
      );
}

void onSelected(BuildContext context, MenuItem item) {
  switch (item) {
    case MenuItems.itemHalte:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => HaltePage()),
      );
      break;
    case MenuItems.itemJumlahUnit:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => UnitPage()),
      );
      break;
    case MenuItems.itemKapasitas:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => KapasitasPage()),
      );
      break;
    case MenuItems.itemJamOperasional:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => JamOperasionalPage()),
      );
      break;
    case MenuItems.itemBiaya:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BiayaPage()),
      );
      break;
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> itemFirst = [
    itemHalte,
    itemJumlahUnit,
    itemKapasitas,
    itemJamOperasional,
    itemBiaya,
  ];
  // static const List<MenuItem> itemSecond = [
  //   itemJumlahUnit,
  //   itemKapasitas,
  //   itemJamOperasional,
  //   itemBiaya,
  // ];

  static const itemHalte =
      MenuItem(text: 'Halte', icon: Icons.nature_people_outlined);
  static const itemJumlahUnit =
      MenuItem(text: 'Jumlah Unit', icon: Icons.directions_bus);
  static const itemKapasitas =
      MenuItem(text: 'Kapasitas', icon: Icons.people_outline);
  static const itemJamOperasional =
      MenuItem(text: 'Jam Operasional', icon: Icons.access_time_outlined);
  static const itemBiaya =
      MenuItem(text: 'Biaya', icon: Icons.attach_money_outlined);
}
