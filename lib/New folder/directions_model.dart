// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:trans_mamminasata/New%20folder/services.dart';
// import 'package:provider/provider.dart';

// class MyApp extends StatelessWidget {
//   final geoService = GeolocatorService();
//   @override
//   Widget build(BuildContext context) {
//     return FutureProvider(
//       create: (context) => geoService.getInitialLocation(),
//       initialData: null,
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: Consumer<Position>(
//           builder: (context, position, widget) {
//             return (position != null)
//                 ? Map(position)
//                 : const Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }