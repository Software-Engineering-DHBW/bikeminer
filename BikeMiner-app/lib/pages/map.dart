import 'dart:async';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:bikeminer/backend/api_connector.dart';
import 'package:bikeminer/backend/storage_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bikeminer/widget/navigation_drawer_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_background/flutter_background.dart';
import '../widget/error_dialog.dart';

class Map extends StatefulWidget {
  final StorageAdapter _sa;
  final APIConnector _api;
  const Map(this._sa, this._api, {Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

/// Map
///
/// Google Maps Card with mylocation marker
class _MapState extends State<Map> {
  late BuildContext _mapcontext;
  late StreamSubscription _locationSubscription;

  final Location _locationTracker = Location();
  late GoogleMapController _controller;
  late Marker marker;
  late Circle circle;
  bool isiniti = false;
  bool controllerisinit = false;
  bool _islocationsubscriped = false;

  double zoomlevel = 10.0;
  bool follow = false;
  bool riding = false;

  DateTime lastsend = DateTime(2000);

  bool backgroundenabled = false;
  bool backgroundpermission = false;
  bool backgroundinit = false;
  final androidConfig = const FlutterBackgroundAndroidConfig(
    notificationTitle: "BikeMiner",
    notificationText: "BikeMiner is recording your Route!",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon:
        AndroidResource(name: 'background_icon', defType: 'drawable'),
  );

  /// first CameraPosition
  ///
  /// Position is 49.4874592, 8.4660395 (Mannheim)
  static const CameraPosition initialLocation = CameraPosition(
    target: LatLng(49.4874592, 8.4660395),
    zoom: 10.0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _mapcontext = context;
    });
    return Scaffold(
      drawer: NavigationDrawerWidget(context, () => logout(), widget._api),
      appBar: AppBar(
        title: const Text(
          "BikeMiner",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 30, 134, 49),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            compassEnabled: true,
            initialCameraPosition: initialLocation,
            zoomControlsEnabled: false,
            markers: Set.of((isiniti) ? [marker] : []),
            circles: Set.of((isiniti) ? [circle] : []),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              controllerisinit = true;
            },
            onCameraIdle: () {
              setState(() {
                setzoomlevel();
              });
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Wrap(
                    //will break to another line on overflow
                    direction:
                        Axis.vertical, //use vertical to show  on vertical axis
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: FloatingActionButton(
                            heroTag: "1",
                            child: follow
                                ? const Icon(Icons.near_me)
                                : const Icon(Icons.near_me_disabled),
                            onPressed: () {
                              setState(() {
                                follow = !follow;
                              });
                            },
                            elevation: 10.0,
                          )),
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: FloatingActionButton(
                            heroTag: "2",
                            child: const Icon(Icons.location_searching),
                            onPressed: () {
                              setState(() {
                                follow = true;
                              });
                              getCurrentLocation();
                            },
                            elevation: 10.0,
                          )),
                    ])),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton.extended(
                heroTag: "3",
                icon: const Icon(Icons.directions_bike_rounded),
                label: riding
                    ? const Text('Stop riding!')
                    : const Text('Start riding!'),
                tooltip: 'Increment',
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                backgroundColor: const Color.fromARGB(255, 31, 148, 40),
                elevation: 10.0,
                onPressed: () {
                  if (!riding) {
                    getCurrentLocation();
                  } else {
                    debugPrint("aufh??ren");
                    widget._api.stopriding();
                  }
                  setState(() {
                    riding = !riding;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  /// initialize FlutterBackground
  ///
  /// ask the user to run the app in the background
  Future<void> initializeBackground() async {
    if (!backgroundpermission) {
      bool initializebool =
          await FlutterBackground.initialize(androidConfig: androidConfig);
      setState(() {
        backgroundinit = initializebool;
        backgroundpermission = initializebool;
      });
    }
    enableBackgroundMode();
  }

  /// enable BackgoundMode
  ///
  /// if the user allow by usage the settings are opened for selecting alows always
  /// for the backgroundusage
  Future<bool> enableBackgroundMode() async {
    bool _bgModeEnabled = await _locationTracker.isBackgroundModeEnabled();
    if (_bgModeEnabled) {
      return true;
    } else {
      try {
        _bgModeEnabled = await _locationTracker.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      debugPrint("$_bgModeEnabled"); //True!
      return _bgModeEnabled;
    }
  }

  /// set the current zoom level
  Future<void> setzoomlevel() async {
    zoomlevel = await _controller.getZoomLevel();
  }

  /// subscripe the location data and set the
  void getCurrentLocation() async {
    setState(() {
      follow = true;
    });
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updatePosition(location, imageData);

      if (_islocationsubscriped) {
        _locationSubscription.cancel();
        _islocationsubscriped = false;
      }
      zoomlevel = 15.0;
      _islocationsubscriped = true;
      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) async {
        if (controllerisinit) {
          if (follow) {
            _controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    bearing: newLocalData.heading!,
                    target: LatLng(newLocalData.latitude as double,
                        newLocalData.longitude as double),
                    tilt: 0,
                    zoom: zoomlevel)));
          }
          updatePosition(newLocalData, imageData);
          if (riding) {
            if (!backgroundpermission) {
              riding = false;
              await initializeBackground();
              if (!backgroundpermission) {
                setState(() {
                  riding = false;
                });
                showMyDialog(
                    _mapcontext,
                    "Permission Warning",
                    "The App needs the Permission to run in Background for recording your route!",
                    "You can change the Permission from Settings > Apps & notifications!");
              }
            }
            if (backgroundpermission) {
              riding = true;
              if (!backgroundenabled) {
                FlutterBackground.enableBackgroundExecution().then((value) {
                  setState(() {
                    backgroundenabled = value;
                  });
                });
              }
              await startRiding(newLocalData);
            }
          } else if (backgroundenabled) {
            debugPrint("disable background!");
            _locationTracker.enableBackgroundMode(enable: false);
            FlutterBackground.disableBackgroundExecution().then((value) {
              setState(() {
                backgroundenabled = !value;
              });
            });
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission denied!");
      }
    }
  }

  /// for canceling the location subscription and for logging out
  Future<int> logout() async {
    if (_islocationsubscriped) {
      setState(() {
        riding = false;
      });
      _locationSubscription.cancel();
    }
    widget._api.logout();
    widget._sa.deleteAll();
    return 0;
  }

  /// load the markerimage in bytedata
  ///
  /// return Uint8List
  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/location_icon_2.png");
    return byteData.buffer.asUint8List();
  }

  /// for start the intervall gps location upload to the server
  Future<void> startRiding(LocationData newLocalData) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-ddTkk:mm:ss').format(now);
    if (now.difference(lastsend).inSeconds > 8) {
      lastsend = now;
      debugPrint(
          "Timestamp: $formattedDate, Lat: ${newLocalData.latitude}, Long: ${newLocalData.longitude}");
      var res = await widget._api.sendcoordinates(
          newLocalData.latitude, newLocalData.longitude, formattedDate);
      if (res == 503 && riding == true) {
        riding = false;
        showMyDialog(
            _mapcontext,
            "Server Error",
            "The Server is not reachable!",
            "Ensure the network connection is valid!");
      }
    }
  }

  /// for updating the positionmarker on the map
  void updatePosition(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(
        newLocalData.latitude as double, newLocalData.longitude as double);
    setState(() {
      marker = Marker(
          markerId: const MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: const CircleId("bike"),
          radius: newLocalData.accuracy!,
          zIndex: 1,
          strokeColor: const Color.fromARGB(0, 33, 149, 243), //Colors.blue,
          center: latlng,
          fillColor: const Color.fromARGB(73, 33, 149, 243));
      isiniti = true;
    });
  }
}
