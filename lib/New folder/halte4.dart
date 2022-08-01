import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trans_mamminasata/New%20folder/halte1.dart';
import 'package:trans_mamminasata/New%20folder/halte2.dart';
import 'package:trans_mamminasata/New%20folder/halte3.dart';
import 'package:trans_mamminasata/New%20folder/kapasitas.dart';
import 'package:trans_mamminasata/New%20folder/unit.dart';

import 'biaya.dart';
import 'jam_operasional.dart';

class Halte4Page extends StatelessWidget {
  const Halte4Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Informasi Angkutan'),
          centerTitle: true,
          backgroundColor: Colors.brown[700],
          actions: [
            PopupMenuButton<MenuItem>(
                icon: Icon(Icons.menu),
                onSelected: ((item) => onSelected(context, item)),
                itemBuilder: (context) =>
                    [...MenuItems.itemFirst.map(buildItem).toList()])
          ],
          bottom: PreferredSize(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const HaltePage();
                        }));
                      },
                      child: const Text("Koridor 1", textScaleFactor: 0.7),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.brown[900]),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const Halte2Page();
                        }));
                      },
                      child: const Text("Koridor 2", textScaleFactor: 0.7),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.brown[900]),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const Halte3Page();
                        }));
                      },
                      child: const Text("Koridor 3", textScaleFactor: 0.7),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.brown[900]),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const Halte4Page();
                        }));
                      },
                      child: const Text(
                        "Koridor 4",
                        textScaleFactor: 0.7,
                        style: TextStyle(color: Colors.brown),
                      ),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.brown[100]),
                    ),
                  ),
                ],
              ),
              preferredSize: const Size.fromHeight(40)),
        ),
        body:
            // Column(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       // child: AspectRatio(
            //       //   aspectRatio: 9 / 16,
            //       child:
            Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.brown[100],
            child: ListView(
              children: const [
                Text(
                  'Koridor 4 : Kampus Teknik Unhas Gowa – Mall Panakukkang',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'PDAM GOWA IKK BORONGLOE -  Politeknik Pembangunan Pertanian Gowa -  GRIYA KENARI SAMATA -  SMK PELAYARAN TARUNA NUSANTARA -  MASJID BAITURRAHMAN -  Mutiara Indah Village -  Pesantren GUPPI Samata -  Pintu 1 Kampus II UIN Alauddin Makassar -  Balai Diklat PKN BPK RI -  Grand Aliyah -  Masjid AL-INSAN Taman Zarindah -  PONDOK LIMA PUTRI MACANDA -  R3 Sentosa Land -  Kantor Lurah Mawang -  PLN UPDL Makassar -  Asrama mawang Rindam XIV HSN -  Halte Teknik UNHAS -  Naufal Medika Apotek -  Masjid Muhammad Cheng Hoo -  Bumi Aroeppala -  Royal Spring -  Universitas Patria Artha -  Perumahan BTN Pao-pao Permai -  McDonalds Tun Abdul Razak -  CitraLand Celebes -  Minasaupa Blok AB -  Belmont Residence -  Aroepala Food City -  Sekolah Menengah Kejuruan Kesehatan Mega Rezky -  SPBU Hertasning -  ASRAMA POLISI TODDOPULI MAKASSAR -  JILC TODDOPULI -  TRANSMART Pengayoman -  Sekolah Dasar Katolik Santo Aloysius -  Continent Centrepoint Panakkukang -  PT. Alaska Mandiri Cemerlang',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        // ),
        //     ),
        //   ],
        // ),
        backgroundColor: Colors.brown[300],
      );
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
    // case MenuItems.itemHalte:
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => HaltePage()),
    //   );
    //   break;
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
    // itemHalte,
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

  // static const itemHalte =
  //     MenuItem(text: 'Halte', icon: Icons.nature_people_outlined);
  static const itemJumlahUnit =
      MenuItem(text: 'Jumlah Unit', icon: Icons.directions_bus);
  static const itemKapasitas =
      MenuItem(text: 'Kapasitas', icon: Icons.people_outline);
  static const itemJamOperasional =
      MenuItem(text: 'Jam Operasional', icon: Icons.access_time_outlined);
  static const itemBiaya =
      MenuItem(text: 'Biaya', icon: Icons.attach_money_outlined);
}
