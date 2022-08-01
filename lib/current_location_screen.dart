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

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(-5.1577208, 119.4486481), zoom: 11);

  final Set<Marker> markers = {};
  final Set<Polyline> _polylines = <Polyline>{};

  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  late Marker destiation;
  late BitmapDescriptor koridor1;
  late BitmapDescriptor koridor2;
  late BitmapDescriptor koridor3;
  late BitmapDescriptor koridor4;
  late BitmapDescriptor halte1;
  late BitmapDescriptor halte2;
  late BitmapDescriptor halte3;
  late BitmapDescriptor halte4;

  void setMarker() async {
    koridor1 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/k1.png");
    koridor2 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/k2.png");
    koridor3 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/k3.png");
    koridor4 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/k4.png");
    halte1 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/h1.png");
    halte2 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/h2.png");
    halte3 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/h3.png");
    halte4 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/h4.png");
  }

  @override
  void initState() {
    super.initState();

    polylinePoints = PolylinePoints();
    setMarker();
  }

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
            preferredSize: const Size.fromHeight(60)),
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        // polylines: _polyline,
        polylines: _polylines,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
          _get4Polylines();
          marker();
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
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarker,
          ));

          marker();
        },
        backgroundColor: Colors.brown[700],
        label: const Text("Lokasi Anda"),
        icon: const Icon(Icons.location_history),
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
                borderSide: const BorderSide(color: Colors.white))),
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
    markers.add(destiation = Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    marker();

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  Future<Set<Polyline>> _get4Polylines() async {
    // Use your location.
    const firstPolylineStart = LatLng(-5.1577208, 119.4486481);
    const firstPolylineFinish = LatLng(-5.151885263099041, 119.4343190651094);

    final firsPolyline = await _getRoutePolyline(
      start: firstPolylineStart,
      finish: firstPolylineFinish,
      color: Colors.yellow,
      id: 'Koridor 1',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(
              firstPolylineStart.latitude, firstPolylineFinish.longitude)),
    );
    const f1PolylineStart = LatLng(-5.151902856046432, 119.43432705926888);
    const f1PolylineFinish = LatLng(-5.146721317382815, 119.42147588065723);

    final f1Polyline = await _getRoutePolyline(
      start: f1PolylineStart,
      finish: f1PolylineFinish,
      color: Colors.yellow,
      id: 'Koridor-11',
      marker: Marker(
          markerId: const MarkerId('currentLocatio'),
          position:
              LatLng(f1PolylineStart.latitude, f1PolylineFinish.longitude)),
    );

    const f2PolylineStart = LatLng(-5.146721317382815, 119.42147588065723);
    const f2PolylineFinish = LatLng(-5.152033164195469, 119.42067678899224);

    final f2Polyline = await _getRoutePolyline(
      start: f2PolylineStart,
      finish: f2PolylineFinish,
      color: Colors.yellow,
      id: 'Koridor-12',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(f2PolylineStart.latitude, f2PolylineFinish.longitude)),
    );
    const f3PolylineStart = LatLng(-5.152033164195469, 119.42067678899224);
    const f3PolylineFinish = LatLng(-5.148864050972914, 119.4144700868322);

    final f3Polyline = await _getRoutePolyline(
      start: f3PolylineStart,
      finish: f3PolylineFinish,
      color: Colors.yellow,
      id: 'Koridor13',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(f3PolylineStart.latitude, f3PolylineFinish.longitude)),
    );
    const f4PolylineStart = LatLng(-5.148864050972914, 119.4144700868322);
    const f4PolylineFinish = LatLng(-5.2120365291696364, 119.39378264666585);

    final f4Polyline = await _getRoutePolyline(
      start: f4PolylineStart,
      finish: f4PolylineFinish,
      color: Colors.yellow,
      id: 'Koridor14',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(f4PolylineStart.latitude, f4PolylineFinish.longitude)),
    );
    const f5PolylineStart = LatLng(-5.2120365291696364, 119.39378264666585);
    const f5PolylineFinish = LatLng(-5.3265937, 119.3594703);

    final f5Polyline = await _getRoutePolyline(
      start: f5PolylineStart,
      finish: f5PolylineFinish,
      color: Colors.yellow,
      id: 'Koridor15',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(f5PolylineStart.latitude, f5PolylineFinish.longitude)),
    );

    // Use your location.
    const secondPolylineStart = LatLng(-5.103385795588682, 119.47771560629245);
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
    const s1PolylineStart = LatLng(-5.156867428902749, 119.44706138138577);
    const s1PolylineFinish = LatLng(-5.161900201365424, 119.45744987856423);

    final s1Polyline = await _getRoutePolyline(
      start: s1PolylineStart,
      finish: s1PolylineFinish,
      color: Colors.red,
      id: 'Koridor-21',
      marker: Marker(
          markerId: const MarkerId("images/k2.png"),
          position:
              LatLng(s1PolylineStart.latitude, s1PolylineFinish.longitude)),
    );
    const s3PolylineStart = LatLng(-5.103385795588682, 119.47771560629245);
    const s3PolylineFinish = LatLng(-5.128366734879654, 119.49993166204928);

    final s3Polyline = await _getRoutePolyline(
      start: s3PolylineStart,
      finish: s3PolylineFinish,
      color: Colors.red,
      id: 'Koridor-22',
      marker: Marker(
          markerId: const MarkerId("images/k2.png"),
          position:
              LatLng(s3PolylineStart.latitude, s3PolylineFinish.longitude)),
    );
    const s4PolylineStart = LatLng(-5.1424351675295945, 119.45720036816016);
    const s4PolylineFinish = LatLng(-5.128366734879654, 119.49993166204928);

    final s4Polyline = await _getRoutePolyline(
      start: s4PolylineStart,
      finish: s4PolylineFinish,
      color: Colors.red,
      id: 'Koridor-23',
      marker: Marker(
          markerId: const MarkerId("images/k2.png"),
          position:
              LatLng(s4PolylineStart.latitude, s4PolylineFinish.longitude)),
    );
    const s5PolylineStart = LatLng(-5.161900201365424, 119.45744987856423);
    const s5PolylineFinish = LatLng(-5.1424351675295945, 119.45720036816016);

    final s5Polyline = await _getRoutePolyline(
      start: s5PolylineStart,
      finish: s5PolylineFinish,
      color: Colors.red,
      id: 'Koridor-24',
      marker: Marker(
          markerId: const MarkerId("images/k2.png"),
          position:
              LatLng(s5PolylineStart.latitude, s5PolylineFinish.longitude)),
    );
    const thirdPolylineStart = LatLng(-5.144918, 119.523754);
    const thirdPolylineFinish = LatLng(-5.10023173548673, 119.52321102669609);

    final thirdPolyline = await _getRoutePolyline(
      start: thirdPolylineStart,
      finish: thirdPolylineFinish,
      color: Colors.blue,
      id: 'Koridor 3',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(
              thirdPolylineStart.latitude, thirdPolylineFinish.longitude)),
    );
    const t1PolylineStart = LatLng(-5.063431, 119.478964);
    const t1PolylineFinish = LatLng(-5.089976710470711, 119.47489974926496);

    final t1Polyline = await _getRoutePolyline(
      start: t1PolylineStart,
      finish: t1PolylineFinish,
      color: Colors.blue,
      id: 'Koridor-31',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(t1PolylineStart.latitude, t1PolylineFinish.longitude)),
    );
    const t2PolylineStart = LatLng(-5.089976710470711, 119.47489974926496);
    const t2PolylineFinish = LatLng(-5.063431, 119.478964);

    final t2Polyline = await _getRoutePolyline(
      start: t2PolylineStart,
      finish: t2PolylineFinish,
      color: Colors.blue,
      id: 'Koridor-32',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(t2PolylineStart.latitude, t2PolylineFinish.longitude)),
    );
    const t3PolylineStart = LatLng(-5.10023173548673, 119.52321102669609);
    const t3PolylineFinish = LatLng(-5.110198013638964, 119.51116587692051);

    final t3Polyline = await _getRoutePolyline(
      start: t3PolylineStart,
      finish: t3PolylineFinish,
      color: Colors.blue,
      id: 'Koridor-33',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(t3PolylineStart.latitude, t3PolylineFinish.longitude)),
    );
    const t4PolylineStart = LatLng(-5.0883867141107, 119.4816978568162);
    const t4PolylineFinish = LatLng(-5.110198013638964, 119.51116587692051);

    final t4Polyline = await _getRoutePolyline(
      start: t4PolylineStart,
      finish: t4PolylineFinish,
      color: Colors.blue,
      id: 'Koridor-34',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(t4PolylineStart.latitude, t4PolylineFinish.longitude)),
    );

    const fourPolylineStart = LatLng(-5.2319611, 119.4989909);
    const fourPolylineFinish = LatLng(-5.156758157117813, 119.44623905421224);

    final fourPolyline = await _getRoutePolyline(
      start: fourPolylineStart,
      finish: fourPolylineFinish,
      color: Colors.green,
      id: 'Koridor 4',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(fourPolylineStart.latitude, fourPolylineFinish.longitude)),
    );
    const f6PolylineStart = LatLng(-5.2319611, 119.4989909);
    const f6PolylineFinish = LatLng(-5.231536109998438, 119.50396447380685);

    final f6Polyline = await _getRoutePolyline(
      start: f6PolylineStart,
      finish: f6PolylineFinish,
      color: Colors.green,
      id: 'Koridor-41',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(f6PolylineStart.latitude, f6PolylineFinish.longitude)),
    );
    const f7PolylineStart = LatLng(-5.231536109998438, 119.50396447380685);
    const f7PolylineFinish = LatLng(-5.20652039163956, 119.50441724150586);

    final f7Polyline = await _getRoutePolyline(
      start: f7PolylineStart,
      finish: f7PolylineFinish,
      color: Colors.green,
      id: 'Koridor-42',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(f7PolylineStart.latitude, f7PolylineFinish.longitude)),
    );
    const f8PolylineStart = LatLng(-5.20652039163956, 119.50441724150586);
    const f8PolylineFinish = LatLng(-5.162804026379397, 119.45258027017991);

    final f8Polyline = await _getRoutePolyline(
      start: f8PolylineStart,
      finish: f8PolylineFinish,
      color: Colors.green,
      id: 'Koridor-43',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(f8PolylineStart.latitude, f8PolylineFinish.longitude)),
    );
    const f9PolylineStart = LatLng(-5.162804026379397, 119.45258027017991);
    const f9PolylineFinish = LatLng(-5.15823079437527, 119.43969613554948);

    final f9Polyline = await _getRoutePolyline(
      start: f9PolylineStart,
      finish: f9PolylineFinish,
      color: Colors.green,
      id: 'Koridor-44',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(f9PolylineStart.latitude, f9PolylineFinish.longitude)),
    );
    const f10PolylineStart = LatLng(-5.156758157117813, 119.44623905421224);
    const f10PolylineFinish = LatLng(-5.15823079437527, 119.43969613554948);

    final f10Polyline = await _getRoutePolyline(
      start: f10PolylineStart,
      finish: f10PolylineFinish,
      color: Colors.green,
      id: 'Koridor-45',
      marker: Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(f10PolylineStart.latitude, f10PolylineFinish.longitude)),
    );

    final Set<Polyline> polylines = {};
    polylines.add(firsPolyline);
    polylines.add(f1Polyline);
    polylines.add(f2Polyline);
    polylines.add(secondPolyline);
    polylines.add(thirdPolyline);
    polylines.add(fourPolyline);

    return polylines;
  }

  Future<void> marker() async => setState(() {
        markers.add(
          Marker(
              markerId: const MarkerId('Koridor 1'),
              position: const LatLng(-5.1577208, 119.4486481),
              icon: koridor1,
              infoWindow: const InfoWindow(
                title: 'Koridor 1',
                snippet: 'Mall Panakukang-Pelabuhan Galesong',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('Koridor 11'),
              position: const LatLng(-5.3265937, 119.3594703),
              icon: koridor1,
              infoWindow: const InfoWindow(
                title: 'Koridor 1',
                snippet: 'Pelabuhan Galesong-Mall Panakukang',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('Koridor 2'),
              position: const LatLng(-5.156867428902749, 119.44706138138577),
              icon: koridor2,
              infoWindow: const InfoWindow(
                title: 'Koridor 2',
                snippet:
                    'Mall Panakkukang – Bandara Internasional Sultan Hasanuddin',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('Koridor 22'),
              position: const LatLng(-5.0781608, 119.5483437),
              icon: koridor2,
              infoWindow: const InfoWindow(
                title: 'Koridor 2',
                snippet:
                    'Bandara Internasional Sultan Hasanuddin-Mall Panakukang',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('Koridor 33'),
              position: const LatLng(-5.144918, 119.523754),
              icon: koridor3,
              infoWindow: const InfoWindow(
                title: 'Koridor 3',
                snippet: 'Kampus 2 PNUP - Kampus 2 PIP',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('Koridor 3'),
              position: const LatLng(-5.063431, 119.478964),
              icon: koridor3,
              infoWindow: const InfoWindow(
                title: 'Koridor 3',
                snippet: 'Kampus 2 PIP - Kampus 2 PNUP',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('Koridor 4'),
              position: const LatLng(-5.2319611, 119.4989909),
              icon: koridor4,
              infoWindow: const InfoWindow(
                title: 'Koridor 4',
                snippet: 'Kampus Teknik UNHAS – Mall Panakukkang',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('Koridor 44'),
              position: const LatLng(-5.156758157117813, 119.44623905421224),
              icon: koridor4,
              infoWindow: const InfoWindow(
                title: 'Koridor 4',
                snippet: 'Mall Panakukang - Kampus Teknik UNHAS',
              )),
        );

        //KORIDOR 1
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte1'),
              position: const LatLng(-5.155629228032721, 119.4391864133832),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Bank BCA',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte2'),
              position: const LatLng(-5.154222687863548, 119.43588232716174),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Grand Maleo Pelita Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte3'),
              position: const LatLng(-5.151885263099041, 119.4343190651094),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'RM Buguri Pelita',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte4'),
              position: const LatLng(-5.149262046693576, 119.43432376697965),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Galaxy Accessories',
              )),
        );

        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte5'),
              position: const LatLng(-5.147938652603982, 119.42885806963592),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Masjid Haji Muhammad Ali',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte6'),
              position: const LatLng(-5.146735863291368, 119.42147644501458),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Hotel Gunung Mas',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte7'),
              position: const LatLng(-5.1498120736931, 119.42169280351138),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Alfamart jl. Rusa',
              )),
        );

        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte8'),
              position: const LatLng(-5.152027570728487, 119.42067792210653),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Sekolah Bosowa Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte9'),
              position: const LatLng(-5.152139059518059, 119.41526105567868),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Waroeng Steak And Shake Kasuari Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte10'),
              position: const LatLng(-5.150440696465416, 119.41462340835828),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Hotel Meliã Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte11'),
              position: const LatLng(-5.148864050972914, 119.4144700868322),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Kumala Group',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte12'),
              position: const LatLng(-5.148606679936443, 119.41063793829834),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Badan Pusat Statistik Provinsi Sulawesi Selatan',
              )),
        );

        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte13'),
              position: const LatLng(-5.14888835909717, 119.40768482487658),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Centre Point of Indonesia (CPI)',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte14'),
              position: const LatLng(-5.150587193130281, 119.40649650617245),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Siloam Hospitals Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte15'),
              position: const LatLng(-5.154159642330809, 119.4044502799123),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Celebes Convention Center',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte16'),
              position: const LatLng(-5.157463377707983, 119.40331683721035),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Gammara Hotel Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte17'),
              position: const LatLng(-5.1605000331639514, 119.40009781289214),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Waterfrontcity Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte18'),
              position: const LatLng(-5.162453314684922, 119.39534375716802),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Trans Studio Mall Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte19'),
              position: const LatLng(-5.169182793349576, 119.39015753424523),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Mall GTC Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte20'),
              position: const LatLng(-5.1781166938381205, 119.39087593915094),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Kuliner Tanjung Bunga',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte21'),
              position: const LatLng(-5.180954083219432, 119.39098464163123),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Simpang Politeknik Pariwisata Makassar',
              )),
        );

        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte22'),
              position: const LatLng(-5.1859257457780155, 119.39014022074798),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Alfamidi Metro Tanjung Bunga Blok H',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte23'),
              position: const LatLng(-5.189104970978628, 119.3875203372573),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'The Amaryllis Residence',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte24'),
              position: const LatLng(-5.196135246086594, 119.38701147820473),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Green River View-Tanjung Bunga',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte25'),
              position: const LatLng(-5.202922083841619, 119.38751049452942),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'STADION BAROMBONG',
              )),
        );

        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte26'),
              position: const LatLng(-5.208972723235121, 119.38971787202769),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Barombong Residence',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte27'),
              position: const LatLng(-5.2120365291696364, 119.39378264666585),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Klinik Multi Sehat Barombong',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte28'),
              position: const LatLng(-5.21444157397063, 119.39251544923498),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Ville Park Residenza',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte29'),
              position: const LatLng(-5.226488653956112, 119.38909459993468),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'R.S Galesong',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte30'),
              position: const LatLng(-5.23714354695418, 119.38825785068055),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Alfamart Green R Barombong',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte31'),
              position: const LatLng(-5.246208592450365, 119.38648430747475),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Donat Kampar Galesong',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte32'),
              position: const LatLng(-5.259659502471819, 119.38424698220706),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Polsek Galesong Utara',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte33'),
              position: const LatLng(-5.266211112193323, 119.38312845259074),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'UD. IFAH',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte34'),
              position: const LatLng(-5.272499333132428, 119.38221506656717),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Simpang Villa Saung Beba',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte35'),
              position: const LatLng(-5.275372589661987, 119.38174097082278),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Simpang PPI Beba',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte36'),
              position: const LatLng(-5.2795952365912635, 119.3802199409306),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Simpang Empat Campagaya',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte37'),
              position: const LatLng(-5.291234414269316, 119.37575511297597),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'SPBU Kalongkong',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte38'),
              position: const LatLng(-5.301623340743758, 119.37441990224744),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Zam-Zam Residence',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte39'),
              position: const LatLng(-5.305151709235998, 119.37285487529317),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'KAMPOENG GALE (cafe & food court)',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte40'),
              position: const LatLng(-5.313480580918295, 119.36910496729003),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Tailor Linda',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k1-halte41'),
              position: const LatLng(-5.317152651991788, 119.36719808516085),
              icon: halte1,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Lapangan H. Larigau Daeng Mangngingruru',
              )),
        );

        //KORIDOR 2
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte1'),
              position: const LatLng(-5.161191563114903, 119.45051788605524),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Carefour Transmarket',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte2'),
              position: const LatLng(-5.162354658088892, 119.45318093772511),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Pasar Toddopulli',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte3'),
              position: const LatLng(-5.161900201365424, 119.45744987856423),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Rumah Sakit Hermina Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte4'),
              position: const LatLng(-5.159424629984536, 119.45921146263046),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Batua Raya 176 (Air Minum Elim)',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte5'),
              position: const LatLng(-5.154009429819305, 119.45874327495119),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Batua 82 Ponsel',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte6'),
              position: const LatLng(-5.151135723816737, 119.46030843970235),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Indomaret Batua Raya No.7',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte7'),
              position: const LatLng(-5.148851590547438, 119.46076142774044),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'SMA Negeri 5 Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte8'),
              position: const LatLng(-5.146143298627637, 119.46100141656375),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Balai Latihan Kerja Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte9'),
              position: const LatLng(-5.144543464186814, 119.46148750836991),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Taman Makam Pahlawan Panaikang',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte10'),
              position: const LatLng(-5.1424351675295945, 119.45720036816016),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Asrama Polisi Panaikang',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte11'),
              position: const LatLng(-5.145861351940594, 119.46837183765517),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'GPIB Mangngamaseang Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte12'),
              position: const LatLng(-5.144330247102848, 119.47462680025787),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Mall Makassar Town Square',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte13'),
              position: const LatLng(-5.141652063090797, 119.48065258620299),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Universitas Islam Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte14'),
              position: const LatLng(-5.141512780133396, 119.48291081038909),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Universitas Dipa Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte15'),
              position: const LatLng(-5.141157532897006, 119.4860898604504),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Padaidi Medical Center',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte16'),
              position: const LatLng(-5.1405038088804, 119.49061245439155),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Pimpinan Wilayah Muhammadiyah',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte17'),
              position: const LatLng(-5.139619984639712, 119.49203633027581),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Dinas Pendidikan Provinsi Sulawesi Selatan',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte18'),
              position: const LatLng(-5.1347478074609825, 119.4971960581288),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Universitas Cokroaminoto Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte19'),
              position: const LatLng(-5.128366734879654, 119.49993166204928),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet:
                    'Badan Arsip Dan Perpustakaan Daerah Propinsi Sulawesi Selatan',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte20'),
              position: const LatLng(-5.131322167843351, 119.49729231059199),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Dinas Kesehatan Provinsi Sulawesi Selatan',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte21'),
              position: const LatLng(-5.125724331796787, 119.4923604751387),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'PT. Borlindo Mandiri Jaya',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte22'),
              position: const LatLng(-5.114359250641485, 119.48522763435037),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'CitraLand Tallasa City Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte23'),
              position: const LatLng(-5.103385795588682, 119.47771560629245),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'PT. Nutrifood Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte24'),
              position: const LatLng(-5.098011242523908, 119.47669168795525),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Pergudangan dan Industri Parangloe',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte25'),
              position: const LatLng(-5.091027096115693, 119.47543847612357),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Depo HINO MAKASSAR',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte26'),
              position: const LatLng(-5.085002876070248, 119.49195124043224),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Toko AL SYAFAAT',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte27'),
              position: const LatLng(-5.082868246707172, 119.49505298193931),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Simpang Salodong Sutami',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte28'),
              position: const LatLng(-5.082000439338997, 119.49706091278439),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Simpang Bontomanai Sutami',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte29'),
              position: const LatLng(-5.081277775376511, 119.49908903061852),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Gudang 45',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte30'),
              position: const LatLng(-5.080593753155711, 119.50232195655225),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'SMP Negeri 9 Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte31'),
              position: const LatLng(-5.078293905391907, 119.50651623439997),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Simpang Caddika Sutami',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte32'),
              position: const LatLng(-5.077239705224238, 119.51033299697129),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Pesantren Darul Arqam Muhammadiyah Gombara',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte33'),
              position: const LatLng(-5.076115675329716, 119.5147601666127),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Gudang pergudangan 88',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte34'),
              position: const LatLng(-5.072044087177483, 119.52026188928366),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Simpang Poros Patene Sutami',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte35'),
              position: const LatLng(-5.067934660676537, 119.52599749514852),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Pintu Masuk Bandara Sultan Hasanuddin',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte36'),
              position: const LatLng(-5.068774610886786, 119.52840680468782),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Hotel Darma Nusantara II',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte37'),
              position: const LatLng(-5.071151129100126, 119.53532822620426),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'RS TNI AU dr. Dody Sardjoto',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k2-halte38'),
              position: const LatLng(-5.074530356715265, 119.5455440571146),
              icon: halte2,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Terminal Bandara Keberangkatan',
              )),
        );

        //KORIDOR 3

        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte2'),
              position: const LatLng(-5.139788073011847, 119.52371748547979),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Pasar Sentral BTP 1',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte3'),
              position: const LatLng(-5.136695171051486, 119.52227595499471),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Perumahan Graha Intiland Regency',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte4'),
              position: const LatLng(-5.130831479829245, 119.52288352761514),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Indomaret BTN Kodam III',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte5'),
              position: const LatLng(-5.124580913584949, 119.52244461743147),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Perumahan Mangga Tiga A',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte6'),
              position: const LatLng(-5.119529996943206, 119.52162035422839),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet:
                    'Kompleks YPPKG (Yayasan Perumahan Pegawai Kantor Gubernur)',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte7'),
              position: const LatLng(-5.11667061303128, 119.51966308895545),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Alfamart Berua Indah',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte8'),
              position: const LatLng(-5.11586777616799, 119.5235118508316),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Perumahan Graha Amalia',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte9'),
              position: const LatLng(-5.111122901366534, 119.52528023549114),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Apotek Ocean Medika',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte10'),
              position: const LatLng(-5.111127404908164, 119.52527979972406),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Alfamart Batarugi',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte11'),
              position: const LatLng(-5.105950418869794, 119.52343208306803),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'KANTOR SAMSAT SUDIANG',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte12'),
              position: const LatLng(-5.1015956685270325, 119.52748140400274),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Bumi Sudiang Raya',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte13'),
              position: const LatLng(-5.1001885260663204, 119.52480341110504),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Wisma Liberty',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte14'),
              position: const LatLng(-5.10023173548673, 119.52321102669609),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'The Victoria',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte15'),
              position: const LatLng(-5.096514696393587, 119.51736595340755),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Indomaret Daeng Ramang',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte116'),
              position: const LatLng(-5.098677829310077, 119.51210706676423),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Griya Athirah Permai ',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte17'),
              position: const LatLng(-5.10279671300582, 119.51129697762293),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Dinas Perhubungan Provinsi Sulawesi Selatan',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte18'),
              position: const LatLng(-5.110198013638964, 119.51116587692051),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Mall Daya Grand Square',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte19'),
              position: const LatLng(-5.112389093396969, 119.50737059114861),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Pasar Daya',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte20'),
              position: const LatLng(-5.109929336607375, 119.5023448474401),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Pusat Suku Cadang Kalla Toyota',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte21'),
              position: const LatLng(-5.104881907279927, 119.49740654260225),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Alfamart Kimia',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte22'),
              position: const LatLng(-5.100842313522653, 119.49578533605384),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Politeknik Bosowa',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte23'),
              position: const LatLng(-5.09519805380236, 119.49347094671411),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'CLUSTER AKASIA TALLASA CITY',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte24'),
              position: const LatLng(-5.09244525030627, 119.48936818602718),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'PT. Cargill Indonesia',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte25'),
              position: const LatLng(-5.089087740180891, 119.48219851402258),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'SMA Negeri 6 Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte26'),
              position: const LatLng(-5.089976710470711, 119.47489974926496),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'AR (Aneka Raya) 99 Toll',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte27'),
              position: const LatLng(-5.0883867141107, 119.4816978568162),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Bira',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte28'),
              position: const LatLng(-5.085928722527454, 119.4879780487382),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'PT. SuracoJaya Abadi Motor - Unit & Spareparts',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte29'),
              position: const LatLng(-5.075805372418035, 119.48466405641375),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Alfamart Salodong',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k3-halte30'),
              position: const LatLng(-5.0694475587883865, 119.47420648048741),
              icon: halte3,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet:
                    'Balai Rehabilitasi Sosial Anak Memerlukan Perlindungan Khusus (BRSAMPK)',
              )),
        );

        //KORIDOR 4
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte1'),
              position: const LatLng(-5.2283262865174205, 119.50064490106755),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'PDAM GOWA IKK BORONGLOE',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte2'),
              position: const LatLng(-5.222139859409529, 119.50702090278044),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Politeknik Pembangunan Pertanian Gowa',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte3'),
              position: const LatLng(-5.220714625913981, 119.50540122861872),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'GRIYA KENARI SAMATA',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte4'),
              position: const LatLng(-5.2283262865174205, 119.50064490106755),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'SMK PELAYARAN TARUNA NUSANTARA',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte5'),
              position: const LatLng(-5.208848374420068, 119.50848537419364),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'MASJID BAITURRAHMAN',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte6'),
              position: const LatLng(-5.206442102144452, 119.50865559230061),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Mutiara Indah Village',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte7'),
              position: const LatLng(-5.20652039163956, 119.50441724150586),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Pesantren GUPPI Samata',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte8'),
              position: const LatLng(-5.202345733871371, 119.49597331008317),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Pintu 1 Kampus II UIN Alauddin Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte9'),
              position: const LatLng(-5.2018010356477, 119.49134108249181),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Balai Diklat PKN BPK RI',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte10'),
              position: const LatLng(-5.207291016015271, 119.48982638812588),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Grand Aliyah',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte11'),
              position: const LatLng(-5.211267115343863, 119.48591633938155),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Masjid AL-INSAN Taman Zarindah',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte12'),
              position: const LatLng(-5.215735121493587, 119.48571220049166),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'PONDOK LIMA PUTRI MACANDA',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte13'),
              position: const LatLng(-5.222515707830843, 119.4846190709211),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'R3 Sentosa Land',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte14'),
              position: const LatLng(-5.223552444403275, 119.49143888287395),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Kantor Lurah Mawang',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte15'),
              position: const LatLng(-5.224142838897884, 119.49360003355913),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'PLN UPDL Makassar',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte16'),
              position: const LatLng(-5.225306351265568, 119.4967159932421),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Asrama mawang Rindam XIV HSN',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte17'),
              position: const LatLng(-5.231536109998438, 119.50396447380685),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Halte Teknik UNHAS',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte18'),
              position: const LatLng(-5.198409932321822, 119.48523157776681),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Naufal Medika Apotek',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte19'),
              position: const LatLng(-5.196943697444251, 119.48330700263128),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Masjid Muhammad Cheng Hoo',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte20'),
              position: const LatLng(-5.192972129769103, 119.48011528994296),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Bumi Aroeppala',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte21'),
              position: const LatLng(-5.190237400121607, 119.47795094838499),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Royal Spring',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte22'),
              position: const LatLng(-5.188854530222402, 119.47639000501198),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Universitas Patria Artha',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte23'),
              position: const LatLng(-5.18635255491253, 119.4730135329293),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Perumahan BTN Pao-pao Permai',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte24'),
              position: const LatLng(-5.181042743558693, 119.46638646606111),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'McDonalds Tun Abdul Razak',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte25'),
              position: const LatLng(-5.179892698541308, 119.46468359861356),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'CitraLand Celebes',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte26'),
              position: const LatLng(-5.178344744928971, 119.46159828078086),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Minasaupa Blok AB',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte27'),
              position: const LatLng(-5.176439670415546, 119.45749011341186),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Belmont Residence',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte28'),
              position: const LatLng(-5.173949354853253, 119.4547519224585),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Aroepala Food City',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte29'),
              position: const LatLng(-5.17211116038434, 119.45264579040887),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Sekolah Menengah Kejuruan Kesehatan Mega Rezky',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte30'),
              position: const LatLng(-5.167893679683554, 119.44887868658239),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'SPBU Hertasning',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte31'),
              position: const LatLng(-5.165746268001039, 119.44993368565417),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'ASRAMA POLISI TODDOPULI MAKASSAR',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte32'),
              position: const LatLng(-5.162804026379397, 119.45258027017991),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'JILC TODDOPULI',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte33'),
              position: const LatLng(-5.161289894447564, 119.45045601581823),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'TRANSMART Pengayoman',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte34'),
              position: const LatLng(-5.165153645976143, 119.44634125170778),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Sekolah Dasar Katolik Santo Aloysius',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte35'),
              position: const LatLng(-5.161333275438187, 119.44564514862135),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'Continent Centrepoint Panakkukang',
              )),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('k4-halte36'),
              position: const LatLng(-5.15823079437527, 119.43969613554948),
              icon: halte4,
              infoWindow: const InfoWindow(
                title: 'Halte Bus Mamminasata',
                snippet: 'PT. Alaska Mandiri Cemerlang',
              )),
        );
        // markers.add(
        //   Marker(
        //       markerId: MarkerId('k4-halte37'),
        //       position: LatLng(-5.156421385649245, 119.43695168649482),
        //       icon: halte4,
        //       infoWindow: const InfoWindow(
        //         title: 'Halte Bus Mamminasata',
        //         snippet: 'Politeknik STIA LAN Makassar',
        //       )),
        // );
      });
}
