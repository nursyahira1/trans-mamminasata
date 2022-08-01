import 'package:flutter/material.dart';
import 'package:trans_mamminasata/New%20folder/halte1.dart';
import 'package:trans_mamminasata/New%20folder/jam_operasional.dart';
import 'package:trans_mamminasata/New%20folder/kapasitas.dart';
import 'package:trans_mamminasata/New%20folder/unit.dart';

class BiayaPage extends StatelessWidget {
  const BiayaPage({Key? key}) : super(key: key);

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
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.brown[100],
            child: ListView(
              children: [
                Text(
                  'Biaya Perjalanan Bus Mamminasata',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Tarif yang diberlakukan adalah sebesar Rp5.000 sekali jalan. ',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Trans Mamminasata juga memberlakukan metode pembayaran non-tunai yang bekerjasama dengan LinkAja, T-Money, OVO, Sakuku, Go-Mobile, Dana, dan GoPay. Di samping itu metode pembayaran tunai juga masih berlaku.',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Jam Operasional Bus Mamminasata',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Jadwal operasional 05.00 - 22.00 WITA',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Kapasitas Bus Mamminasata',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Armada bus sedang berkapasitas 40 penumpang dengan 20 tempat duduk dan bus besar yang berkapasitas 60 penumpang dengan 30 tempat duduk dengan masing-masing 1 area untuk prioritas.',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Jumlah Unit Bus Mamminasata',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Angkutan Bus Rapid Transit (BRT) ini menjadi penunjang mobilisasi masyarakat Makassar dengan jumlah armada sebanyak total 87 unit.',
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
    // case MenuItems.itemBiaya:
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => BiayaPage()),
    //   );
    //   break;
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
    // itemBiaya,
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
  // static const itemBiaya =
  //     MenuItem(text: 'Biaya', icon: Icons.attach_money_outlined);
}
