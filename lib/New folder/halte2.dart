import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trans_mamminasata/New%20folder/halte1.dart';
import 'package:trans_mamminasata/New%20folder/halte3.dart';
import 'package:trans_mamminasata/New%20folder/halte4.dart';
import 'package:trans_mamminasata/New%20folder/kapasitas.dart';
import 'package:trans_mamminasata/New%20folder/unit.dart';

import 'biaya.dart';
import 'jam_operasional.dart';

class Halte2Page extends StatelessWidget {
  const Halte2Page({Key? key}) : super(key: key);

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
                      onPressed: () {Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const HaltePage();
                        }));},
                      child: const Text("Koridor 1", textScaleFactor: 0.7),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.brown[900]),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const Halte2Page();
                        }));},
                      child: const Text("Koridor 2", textScaleFactor: 0.7, style: TextStyle(color: Colors.brown),),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.brown[100]),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const Halte3Page();
                        }));},
                      child: const Text("Koridor 3", textScaleFactor: 0.7),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.brown[900]),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const Halte4Page();
                        }));},
                      child: const Text("Koridor 4", textScaleFactor: 0.7),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.brown[900]),
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
                  'Koridor 2 : Mall Panakkukang – Bandara Internasional Sultan Hasanuddin',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Carefour Transmarket -  Pasar Toddopulli -  Rumah Sakit Hermina Makassar -  Batua Raya 176 (Air Minum Elim) -  Batua 82 Ponsel -  Indomaret Batua Raya No.7 -  SMA Negeri 5 Makassar -  Balai Latihan Kerja Makassar -  Taman Makam Pahlawan Panaikang -  Asrama Polisi Panaikang -  GPIB Mangngamaseang Makassar -  Mall Makassar Town Square -  Universitas Islam Makassar -  Universitas Dipa Makassar -  Padaidi Medical Center -  Pimpinan Wilayah Muhammadiyah -  Dinas Pendidikan Provinsi Sulawesi Selatan -  Universitas Cokroaminoto Makassar -  Badan Arsip Dan Perpustakaan Daerah Propinsi Sulawesi Selatan -  Dinas Kesehatan Provinsi Sulawesi Selatan -  PT. Borlindo Mandiri Jaya -  CitraLand Tallasa City Makassar -  PT. Nutrifood Makassar -  Pergudangan dan Industri Parangloe -  Depo HINO MAKASSAR -  Toko AL SYAFAAT -  Simpang Salodong Sutami -  Simpang Bontomanai Sutami -  Gudang 45 -  SMP Negeri 9 Makassar -  Simpang Caddika Sutami -  Pesantren Darul Arqam Muhammadiyah Gombara -  Gudang pergudangan 88 -  Simpang Poros Patene Sutami -  Pintu Masuk Bandara Sultan Hasanuddin -  Hotel Darma Nusantara II -  RS TNI AU dr. Dody Sardjoto -  Terminal Bandara Keberangkatan',
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
