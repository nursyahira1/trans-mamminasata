// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// // import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:trans_mamminasata/current_location_screen.dart';
// import 'package:trans_mamminasata/location_provider.dart';

// class Perjalanan extends StatefulWidget {
//   const Perjalanan({Key? key}) : super(key: key);

//   @override
//   _PerjalananState createState() => _PerjalananState();
// }

// const kGoogleApiKey = 'AIzaSyBz_J-1q1Jpdxz1O6OQbImcVTCu7zIBNFc';
// final homeScaffoldKey = GlobalKey<ScaffoldState>();

// class _PerjalananState extends State<Perjalanan> {
//   late GoogleMapController googleMapController;

//   static const CameraPosition initialCameraPosition =
//       CameraPosition(target: LatLng(-5.1578703, 119.4219339), zoom: 11);

//   final Set<Marker> markers = {};
//   final Set<Polyline> _polylines = <Polyline>{};

//   List<LatLng> polylineCoordinates = [];
//   late PolylinePoints polylinePoints;

//   @override
//   void initState() {
//     // ignore: todo
//     // TODO: implement initState
//     super.initState();
//     Provider.of<LocationProvider>(context, listen: false).initalization();
//     polylinePoints = PolylinePoints();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//         providers: [
//           ChangeNotifierProvider(
//             create: (context) => LocationProvider(),
//             child: Perjalanan(),
//           )
//         ],
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text(
//               "Rute Bus Mamminasata",
//               style: TextStyle(
//                   fontSize: 22.0,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold),
//             ),
//             backgroundColor: Colors.brown[700],
//             centerTitle: true,
//           ),
//           body: googleMapUI(),
//           floatingActionButton: FloatingActionButton.extended(
//             onPressed: () async {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (BuildContext context) {
//                 return const CurrentLocationScreen();
//               }));
//             },
//             backgroundColor: Colors.brown[700],
//             label: const Text("Lakukan Perjalanan"),
//             // icon: const Icon(Icons.location_history),
//           ),
//         ));
//   }

//   Future<Polyline> _getRoutePolyline(
//       {required LatLng start,
//       required LatLng finish,
//       required Color color,
//       required String id,
//       required Marker marker,
//       int width = 6}) async {
//     // Generates every polyline between start and finish
//     final polylinePoints = PolylinePoints();
//     // Holds each polyline coordinate as Lat and Lng pairs
//     final List<LatLng> polylineCoordinates = [];

//     final startPoint = PointLatLng(start.latitude, start.longitude);
//     final finishPoint = PointLatLng(finish.latitude, finish.longitude);

//     final result = await polylinePoints.getRouteBetweenCoordinates(
//       kGoogleApiKey,
//       startPoint,
//       finishPoint,
//     );
//     if (result.status == 'OK') {
//       // loop through all PointLatLng points and convert them
//       // to a list of LatLng, required by the Polyline
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }
//       setState(() {
//         _polylines.add(Polyline(
//             polylineId: PolylineId(id),
//             width: width,
//             color: color,
//             points: polylineCoordinates));
//       });
//     }
//     final polyline = Polyline(
//       polylineId: PolylineId(id),
//       color: color,
//       points: polylineCoordinates,
//       width: width,
//     );
//     return polyline;
//   }

//   Future<Set<Polyline>> _get4Polylines() async {
//     // Use your location.
//     const firstPolylineStart = LatLng(-5.1577208, 119.4486481);
//     const firstPolylineFinish = LatLng(-5.3265937, 119.3594703);

//     final firsPolyline = await _getRoutePolyline(
//       start: firstPolylineStart,
//       finish: firstPolylineFinish,
//       color: Colors.blue,
//       id: 'Koridor 1',
//       marker: Marker(
//           markerId: const MarkerId('currentLocation'),
//           position: LatLng(
//               firstPolylineStart.latitude, firstPolylineFinish.longitude)),
//     );

//     // Use your location.
//     const secondPolylineStart = LatLng(-5.1580293, 119.4488824);
//     const secondPolylineFinish = LatLng(-5.0781608, 119.5483437);

//     final secondPolyline = await _getRoutePolyline(
//       start: secondPolylineStart,
//       finish: secondPolylineFinish,
//       color: Colors.red,
//       id: 'Koridor 2',
//       marker: Marker(
//           markerId: const MarkerId("images/k2.png"),
//           position: LatLng(
//               secondPolylineStart.latitude, secondPolylineFinish.longitude)),
//     );
//     const thirdPolylineStart = LatLng(-5.144918, 119.523754);
//     const thirdPolylineFinish = LatLng(-5.063431, 119.478964);

//     final thirdPolyline = await _getRoutePolyline(
//       start: thirdPolylineStart,
//       finish: thirdPolylineFinish,
//       color: Colors.green,
//       id: 'Koridor 3',
//       marker: Marker(
//           markerId: const MarkerId('currentLocation'),
//           position: LatLng(
//               thirdPolylineStart.latitude, thirdPolylineFinish.longitude)),
//     );

//     const fourPolylineStart = LatLng(-5.2319611, 119.4989909);
//     const fourPolylineFinish = LatLng(-5.1574424, 119.4485268);

//     final fourPolyline = await _getRoutePolyline(
//       start: fourPolylineStart,
//       finish: fourPolylineFinish,
//       color: Colors.yellow,
//       id: 'Koridor 4',
//       marker: Marker(
//           markerId: const MarkerId('currentLocation'),
//           position:
//               LatLng(fourPolylineStart.latitude, fourPolylineFinish.longitude)),
//     );

//     final Set<Polyline> polylines = {};
//     polylines.add(firsPolyline);
//     polylines.add(secondPolyline);
//     polylines.add(thirdPolyline);
//     polylines.add(fourPolyline);

//     return polylines;
//   }

//   Widget googleMapUI() {
//     return Consumer<LocationProvider>(builder: (consumeContext, model, child) {
//       if (model.locationPosition != null) {
//         return GoogleMap(
//           initialCameraPosition: initialCameraPosition,
//           markers: markers,
//           // {_origin, _destination},
//           polylines: _polylines,
//           zoomControlsEnabled: false,
//           mapType: MapType.normal,
//           onMapCreated: (GoogleMapController controller) {
//             googleMapController = controller;
//             _get4Polylines();
//             // koridor2();
//             // koridor3();
//             // koridor4();
//           },
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//         );
//       }
//       return Container(
//         child: Center(child: CircularProgressIndicator()),
//       );
//     });
//   }
// }
