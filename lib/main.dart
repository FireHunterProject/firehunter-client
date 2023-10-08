import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:fire_hunter/const.dart';
import 'package:fire_hunter/fire_data.dart';
import 'package:fire_hunter/firms_api.dart';
import 'package:fire_hunter/menu_page.dart';
import 'package:fire_hunter/middle_page.dart';
import 'package:fire_hunter/report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Hunter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        primarySwatch: Colors.orange,
        // primaryColor: Colors.red,
        useMaterial3: false,
      ),
      home: const MenuPage(
        // title: "Fire Hunter",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isLoading = true;
  late GoogleMapController _controller;

  List<FireData> _fireData = []; //List.empty(growable: true);
  List<Marker> _markers = [];
  // Location location = Location();
  LatLng _userLocation = LatLng(0, 0); // Initial location (0, 0)

  // Define a custom marker icon
  late BitmapDescriptor customIcon;

  @override
  void initState() {
    super.initState();
    // Load a custom marker icon

    // BitmapDescriptor.fromAssetImage(
    //         const ImageConfiguration(
    //           size: Size(0.1, 0.1),
    //         ),
    //         'assets/images/flame.png')
    //     .then((icon) {
    //   setState(() {
    //     customIcon = icon;
    //   });
    // });

    loadPresetData();
  }

  void loadPresetData() async {
    // var location = await _determinePosition();
    var latlng = Constants.mockLocation;//LatLng(location.latitude, location.longitude);

    var userMarker = buildUserMarker(latlng);
    var icon = await loadCustomMarkerIcon();
    var markers = await loadData();
    var finalMakers = markers;

    markers.addAll(userMarker);
    setState(() {
      customIcon = icon;
      _markers = finalMakers;
      isLoading = false;
      _userLocation = latlng;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<List<Marker>> loadData() async {
    var data = await FIRMSApi.parseCsv();
    return buildMarkers(data);
  }

  List<Marker> buildMarkers(List<FireData> data) {
    List<Marker> markers = [];
    for (var d in data) {
      // print(d.confidence);
      try {
        //if(d.confidence == "h") {
        if (int.parse(d.confidence) >= 70) {
          markers.add(
            Marker(
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
                markerId: MarkerId(const Uuid().v4()),
                position: LatLng(d.latitude, d.longitude),
                infoWindow: InfoWindow(title: "Fire spot, confidence: ${d.confidence}%")),
          );
        }
      } catch (e) {}
    }
    return markers;
  }

  List<Marker> buildUserMarker(LatLng userLocation) {
    var userMarker = _markers
        .where((element) => element.mapsId.value == "userMaker")
        .firstOrNull;
    if (userMarker != null) {
      _markers.remove(userMarker);
    }
    var updatedMarkers = _markers;
    updatedMarkers.add(
      Marker(
          markerId: const MarkerId("userMarker"),
          position: userLocation,
          infoWindow: InfoWindow(title: "User location"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)),
    );
    setState(() {
      _markers = updatedMarkers;
      _userLocation = userLocation;
    });
    return updatedMarkers;
  }

  Future<BitmapDescriptor> loadCustomMarkerIcon() async {
    // Load the custom marker image as bytes
    final Uint8List markerIconBytes = await getBytesFromAsset(
        'assets/images/flame.png'); // Replace with the path to your custom marker image

    // Create a BitmapDescriptor from the bytes
    final BitmapDescriptor descriptor =
        BitmapDescriptor.fromBytes(markerIconBytes, size: Size(2, 2));

    return descriptor;
  }

  Future<Uint8List> getBytesFromAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Fire Spots"),
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _userLocation,
                    zoom: 15,
                  ),
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  markers: _markers.toSet(),
                ),
        ),
        // bottomNavigationBar: BottomNavigationBar(items: [IconButton(onPressed: onPressed, icon: icon)]),
        floatingActionButton: isLoading ? Container() : Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: OpenContainer(
                transitionType: ContainerTransitionType.fade,
                transitionDuration: const Duration(milliseconds: 500),
                openBuilder: (BuildContext context, VoidCallback _) {
                  return ReportPage(userLastlcoation: _userLocation,);
                },
                closedElevation: 6.0,
                closedShape: const RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(15))),
                // closedColor: Theme.of(context).colorScheme.inversePrimary,
                closedColor: Theme.of(context).primaryColor,
                closedBuilder:
                    (BuildContext context, VoidCallback openContainer) {
                  return SizedBox(
                    height: 56,
                    width: 56,
                    child: Center(
                      child: Icon(
                        Icons.fire_extinguisher_sharp,
                        size: 28,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  );
                },
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                _controller.animateCamera(
                    CameraUpdate.newLatLngZoom(_userLocation, 14));
              },
              tooltip: 'Locate',
              child: const Icon(Icons.gps_fixed_sharp),
              shape: const RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ],
        ));
  }
}
