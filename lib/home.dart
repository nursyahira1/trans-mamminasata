// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_new, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:trans_mamminasata/New%20folder/halte1.dart';
import 'package:trans_mamminasata/about.dart';
import 'package:trans_mamminasata/current_location_screen.dart';
import 'package:trans_mamminasata/info.dart';
import 'package:trans_mamminasata/perjalanan.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("BRT TRANS MAMMINASATA"),
        backgroundColor: Colors.brown[700],
      ),
      backgroundColor: Colors.brown[100],
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 4,
            child: Container(
              color: Colors.brown[200],
              child: new Image(
                image: AssetImage("images/Jalur-Trans-Mamminasata-768x432.jpg"),
                width: 500,
                height: 500,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(width: 20),
                Flexible(
                  flex: 1,
                  child: Card(
                    margin: EdgeInsets.only(top: 8.0),
                    color: Colors.brown[500],
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Perjalanan()),
                        // );
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const CurrentLocationScreen();
                        }));
                      },
                      splashColor: Colors.greenAccent[100],
                      borderRadius: BorderRadius.circular(35),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 50.0,
                              color: Colors.white,
                            ),
                            Text("Rute Bus",
                                style: new TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                                textAlign: TextAlign.center)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: Card(
                    margin: EdgeInsets.only(top: 8.0),
                    color: Colors.brown[500],
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HaltePage()),
                        );
                      },
                      splashColor: Colors.redAccent[100],
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.bus_alert,
                              size: 50.0,
                              color: Colors.white,
                            ),
                            Text("Info BRT",
                                style: new TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                                textAlign: TextAlign.center)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: Card(
                    margin: EdgeInsets.only(top: 8.0),
                    color: Colors.brown[500],
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => About()),
                        );
                      },
                      splashColor: Colors.lightBlueAccent[100],
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.info_outline,
                              size: 50.0,
                              color: Colors.white,
                            ),
                            Text("Tentang",
                                style: new TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                                textAlign: TextAlign.center)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//           MyHome(title: "Profil Sekolah", icon: Icons.account_balance,warna: Colors.brown,),
//           MyHome(title: "Operasi Teknik Kimia", icon: Icons.library_books, warna: Colors.red,),
//           MyHome(title: "Alat Industri Kimia", icon: Icons.library_books,warna: Colors.teal,),
//           MyHome(title: "About", icon: Icons.info_outline, warna : Colors.blue,),
         
//         ],
//       ),
//     ),
//   );
//   }
// }


// class MyHome extends StatelessWidget {
//  MyHome({required this.title, required this.icon, required this.warna});

//  final String title;
//  final IconData icon;
//  final MaterialColor warna;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(8.0),
//         child: InkWell(
//           onTap : (){},
//           splashColor: Colors.green,
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Icon(
//                       icon,
//                        size: 70.0,
//                        color: warna,
//                        ),
//                     Text(title, style : new TextStyle(fontSize: 17.0,)),

//                   ],
//                 ),
//              ),
//             ),
//           );
//   }
// }