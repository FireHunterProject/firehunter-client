import 'package:fire_hunter/always_disabled_focus_node.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lat_compass/lat_compass.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:uuid/uuid.dart';

class ReportPage extends StatefulWidget {
  final LatLng userLastlcoation;
  const ReportPage({super.key, required this.userLastlcoation});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController _controller = TextEditingController();

  late GoogleMapController _mapController;
  double _fireDistanceInMeters = 200;
  final PageController _pageController = PageController();
  int currentPage = 0;
  double latestZoom = 15;
  double heading = 0;
  bool showLastForm = false;

  LatLng location = const LatLng(-19.4761897, -42.5325777);

  Set<Circle> _circles = Set.from([]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.text = _fireDistanceInMeters.toString();
    updateRadius(_fireDistanceInMeters);
    LatCompass().onUpdate.listen((event) {
      // setState(() {
      //   heading = event.magneticHeading;
      // });
      if (currentPage == 1) {
        _rotateMap(event.trueHeading);
        // heading = atan2(y, x) * 180 / M_PI;
      }
    });
//     magnetometerEvents.listen(
//   (MagnetometerEvent event) {
//     print(event);
//   },
//   onError: (error) {
//     // Logic to handle error
//     // Needed for Android in case sensor is not available
//     },
//   cancelOnError: true,
// );
  }

  Future<void> _captureImage() async {
    final imagePicker = ImagePicker();
    final imageFile = await imagePicker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      showLastFormAction();
    }
  }

  void showLastFormAction() {
    _pageController.animateToPage(2,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    setState(() {
      showLastForm = true;
    });
  }

  void updateRadius(double radius) {
    if (radius > 600) {
      var offset = radius - 600;
      var zoom = 15 - (offset / 1000);
      _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(widget.userLastlcoation, zoom));
      setState(() {
        latestZoom = zoom;
      });
    }
    setState(() {
      _circles = {
        Circle(
          circleId: CircleId(const Uuid().v4()),
          center: widget.userLastlcoation,
          radius: radius,
          strokeWidth: 2,
          strokeColor: Colors.red,
          fillColor: Colors.red.withOpacity(0.3),
        )
      };
      _fireDistanceInMeters = radius;
    });
  }

  // Widget _buildCompass(Widget child) {
  //   return

  //       return Material(
  //         shape: CircleBorder(),
  //         clipBehavior: Clip.antiAlias,
  //         elevation: 4.0,
  //         child: Container(
  //           padding: EdgeInsets.all(16.0),
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //           ),
  //           child: Transform.rotate(
  //             angle: (direction * (math.pi / 180) * -1),
  //             child: Image.asset('assets/compass.jpg'),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _rotateMap(double heading) {
    if (_mapController != null) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: widget.userLastlcoation,
            zoom: latestZoom,
            bearing: 360 - heading,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text("Fire Report"),
        elevation: 0,
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // ElevatedButton(onPressed: (){}, child: Text("I don't know"), style: ButtonStyle(backgroundColor: MaterialSta),)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
              child: showLastForm
                  ? TextField(
                      // focusNode: AlwaysDisabledFocusNode(),
                      // textAlign: TextAlign.end,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        // suffix: Text("meters"),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        ),
                        label: Text(
                          'Additional description',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      maxLines: 14,
                      keyboardType: TextInputType.multiline,
                    )
                  : Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: widget.userLastlcoation,
                            zoom: 15,
                          ),
                          circles: currentPage == 0 ? _circles : Set.from([]),

                          // mapType: MapType.none,
                          zoomControlsEnabled: false,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          compassEnabled: true,
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                        ),
                      ),
                    ),
            ),
          ),
          // Flexible(child: child)
          Flexible(
              child: PageView(
            controller: _pageController,
            onPageChanged: (p) {
              setState(() {
                currentPage = p;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "What is the approximate distance between you and the fire spot? (in meters)",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TextField(
                        focusNode: AlwaysDisabledFocusNode(),
                        textAlign: TextAlign.end,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          suffix: Text("meters"),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0),
                          ),
                          label: Text(
                            'Approximate distance',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        controller: _controller,
                        onChanged: (value) {
                          try {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _fireDistanceInMeters = 0;
                              });
                            } else {
                              var d = double.parse(value);
                              if (d <= 2000) {
                                setState(() {
                                  _fireDistanceInMeters = d;
                                });
                              } else {
                                setState(() {
                                  _fireDistanceInMeters = 2000;
                                });
                              }
                            }
                          } catch (e) {}
                        },
                      ),
                    ),
                    Slider(
                      value: _fireDistanceInMeters,
                      max: 2000,
                      divisions: 20,
                      activeColor: Colors.grey.shade800,
                      thumbColor: Colors.black,
                      label: _fireDistanceInMeters.round().toString(),
                      onChanged: (double value) {
                        _controller.text = value.toString();
                        updateRadius(value);
                      },
                    ),
                    Flexible(
                      // flex: 0,
                      child: ElevatedButton(
                        child: Text(
                          "Next",
                          style: TextStyle(color: Colors.orange),
                        ),
                        onPressed: () {
                          _pageController.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
                child: Column(
                  children: [
                    Text(
                      "Now, pointing your phone downwards head thowards the fire spot to indicate it's direction",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: ElevatedButton(
                        child: Text(
                          "Pointed! Take Photo",
                          style: TextStyle(color: Colors.orange),
                        ),
                        onPressed: () {
                          _captureImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
                child: Column(
                  children: [
                    Text(
                      "Last but not least, write in a few words any detail or description of the fire spot you are reporting.",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: ElevatedButton(
                        child: Text(
                          "Submit report!",
                          style: TextStyle(color: Colors.orange),
                        ),
                        onPressed: () {
                          // _captureImage();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
