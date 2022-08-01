import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trans_mamminasata/New%20folder/halte2.dart';
import 'package:trans_mamminasata/New%20folder/halte3.dart';
import 'package:trans_mamminasata/New%20folder/halte4.dart';
import 'package:trans_mamminasata/New%20folder/kapasitas.dart';
import 'package:trans_mamminasata/New%20folder/unit.dart';

import 'biaya.dart';
import 'jam_operasional.dart';

class HaltePage extends StatelessWidget {
  const HaltePage({Key? key}) : super(key: key);

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
                      child: const Text(
                        "Koridor 1",
                        textScaleFactor: 0.7,
                        style: TextStyle(color: Colors.brown),
                      ),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.brown[100]),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const Halte2Page();
                        }));},
                      child: const Text("Koridor 2", textScaleFactor: 0.7),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.brown[900]),
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
                  'Koridor 1 : Mall Panakukkang - Pelabuhan Galesong',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Bank BCA -  Grand Maleo Pelita Makassar -  RM Buguri Pelita -  Galaxy Accessories -  Masjid Haji Muhammad Ali -  Hotel Gunung Mas -  Alfamart jl. Rusa -  Sekolah Bosowa Makassar -  Waroeng Steak And Shake Kasuari Makassar -  Hotel Meliã Makassar -  Kumala Group -  Badan Pusat Statistik Provinsi Sulawesi Selatan -  Centre Point of Indonesia (CPI) -  Siloam Hospitals Makassar -  Celebes Convention Center -  Gammara Hotel Makassar -  Waterfrontcity Makassar -  Trans Studio Mall Makassar -  Mall GTC Makassar -  Kuliner Tanjung Bunga -  Simpang Politeknik Pariwisata Makassar -  Alfamidi Metro Tanjung Bunga Blok H -  The Amaryllis Residence -  Green River View-Tanjung Bunga -  STADION BAROMBONG -  Barombong Residence -  Klinik Multi Sehat Barombong -  Ville Park Residenza -  R.S Galesong -  Alfamart Green R Barombong -  Donat Kampar Galesong -  Polsek Galesong Utara -  UD. IFAH -  Simpang Villa Saung Beba -  Simpang PPI Beba -  Simpang Empat Campagaya -  SPBU Kalongkong -  Zam-Zam Residence -  KAMPOENG GALE (cafe & food court) -  Tailor Linda -  Lapangan H. Larigau Daeng Mangngingruru',
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
