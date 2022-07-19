import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

const kGoogleApiKey = 'AIzaSyBz_J-1q1Jpdxz1O6OQbImcVTCu7zIBNFc';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;
  // late Marker _origin;
  // late Marker _destination;
  final Mode _mode = Mode.overlay;
  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(-5.1578703, 119.4219339), zoom: 11);

  final Set<Marker> markers = {};
  Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  @override
  void initState() {
    // intilize();
    super.initState();

    polylinePoints = PolylinePoints();
  }

  // intilize() {
  //   Marker start1Marker = Marker(
  //       markerId: MarkerId('Koridor 1'),
  //       position: LatLng(-5.1577208, 119.4486481),
  //       infoWindow: InfoWindow(title: 'Koridor 1'),
  //       icon: BitmapDescriptor.fromJson('images/k1.png'));

  //   Marker finish1Marker = Marker(
  //       markerId: MarkerId('Koridor 1'),
  //       position: LatLng(-5.3265937, 119.3594703),
  //       infoWindow: InfoWindow(title: 'Koridor 1'),
  //       icon: BitmapDescriptor.fromJson('images/k1.png'));

  //   markers.add(start1Marker);
  //   markers.add(finish1Marker);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Perjalanan",
          style: TextStyle(
              fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown[600],
        centerTitle: true,
        bottom: PreferredSize(
            child: ElevatedButton(
              onPressed: _handlePressButton,
              child: const Text("Cari Lokasi Tujuan"),
              style: ElevatedButton.styleFrom(primary: Colors.brown[900]),
            ),
            preferredSize: Size.fromHeight(60)),
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers, //.map((e) => e).toSet(),
        // {_origin, _destination},
        // polylines: _polyline,
        polylines: _polylines,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
          _get4Polylines();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();

          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14)));

          markers.clear();

          markers.add(Marker(
              markerId: const MarkerId('Lokasi Anda'),
              position: LatLng(position.latitude, position.longitude)));

          setState(() {});
        },
        backgroundColor: Colors.brown[700],
        label: const Text("Lokasi Anda"),
        image: 
      ),
    );
  }

  Future<Polyline> _getRoutePolyline(
      {required LatLng start,
      required LatLng finish,
      required Color color,
      required String id,
      required Marker marker,
      int width = 6}) async {
    // Generates every polyline between start and finish
    final polylinePoints = PolylinePoints();
    // Holds each polyline coordinate as Lat and Lng pairs
    final List<LatLng> polylineCoordinates = [];

    final startPoint = PointLatLng(start.latitude, start.longitude);
    final finishPoint = PointLatLng(finish.latitude, finish.longitude);

    final result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      startPoint,
      finishPoint,
    );
    if (result.status == 'OK') {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            polylineId: PolylineId(id),
            width: width,
            color: color,
            points: polylineCoordinates));
      });
    }
    final polyline = Polyline(
      polylineId: PolylineId(id),
      color: color,
      points: polylineCoordinates,
      width: width,
    );
    return polyline;
  }

  Future<Set<Polyline>> _get4Polylines() async {
    // Use your location.
    const firstPolylineStart = LatLng(-5.1577208, 119.4486481);
    const firstPolylineFinish = LatLng(-5.3265937, 119.3594703);

    final firsPolyline = await _getRoutePolyline(
      start: firstPolylineStart,
      finish: firstPolylineFinish,
      color: Colors.blue,
      id: 'Koridor 1',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(
              firstPolylineStart.latitude, firstPolylineFinish.longitude)),
    );

    // Use your location.
    const secondPolylineStart = LatLng(-5.1580293, 119.4488824);
    const secondPolylineFinish = LatLng(-5.0781608, 119.5483437);

    final secondPolyline = await _getRoutePolyline(
      start: secondPolylineStart,
      finish: secondPolylineFinish,
      color: Colors.red,
      id: 'Koridor 2',
      marker: Marker(
          markerId: const MarkerId("images/k2.png"),
          position: LatLng(
              secondPolylineStart.latitude, secondPolylineFinish.longitude)),
    );
    const thirdPolylineStart = LatLng(-5.144918, 119.523754);
    const thirdPolylineFinish = LatLng(-5.063431, 119.478964);

    final thirdPolyline = await _getRoutePolyline(
      start: thirdPolylineStart,
      finish: thirdPolylineFinish,
      color: Colors.green,
      id: 'Koridor 3',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(
              thirdPolylineStart.latitude, thirdPolylineFinish.longitude)),
    );

    const fourPolylineStart = LatLng(-5.2319611, 119.4989909);
    const fourPolylineFinish = LatLng(-5.1574424, 119.4485268);

    final fourPolyline = await _getRoutePolyline(
      start: fourPolylineStart,
      finish: fourPolylineFinish,
      color: Colors.yellow,
      id: 'Koridor 4',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(fourPolylineStart.latitude, fourPolylineFinish.longitude)),
    );

    final Set<Polyline> polylines = {};
    polylines.add(firsPolyline);
    polylines.add(secondPolyline);
    polylines.add(thirdPolyline);
    polylines.add(fourPolyline);

    return polylines;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country, "id")]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markers.clear();
    markers.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }
}
