// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:trans_mamminasata/New%20folder/services.dart';

// class OrderTraking extends StatefulWidget {
//   const OrderTraking({Key? key}) : super(key: key);

//   @override
//   State<OrderTraking> createState() => _OrderTrakingState();
// }

// class _OrderTrakingState extends State<OrderTraking> {
//   final Completer<GoogleMapController> _controller = Completer();

//   static const LatLng sourceLocation = LatLng(-5.2367511, 119.3355341);
//   static const LatLng destination = LatLng(-5.3265937, 119.3594703);

//   List<LatLng> polylineCoordinates = [];

//   void getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       google_api_key,
//       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//     );

//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) =>
//           polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     getPolyPoints();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Track Order",
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: sourceLocation,
//           zoom: 14.5,
//         ),
//         polylines: {
//           Polyline(
//             polylineId: PolylineId("route"),
//             points: polylineCoordinates,
//             color: primaryColor,
//             width: 6,
//           )
//         },
//         markers: {
//           const Marker(
//             markerId: MarkerId("source"),
//             position: sourceLocation,
//           ),
//           const Marker(
//             markerId: MarkerId("destination"),
//             position: destination,
//           )
//         },
//       ),
//     );
//   }
// }
