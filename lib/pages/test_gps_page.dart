import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/error_dialog.dart';
import 'package:location/location.dart';

/// daudgwaiudw
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  bool _isListenLocation = false;
  late StreamSubscription _s;
  Text buttontext = const Text('Start listening Location');
  late StreamBuilder st;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                streambutton(context),
              ]),
        ));
  }

  void streamsub() {
    Stream s = location.onLocationChanged;

    _s = s.listen((value) {
      var data = value as LocationData;
      debugPrint('Location: ${data.latitude}/${data.longitude}');
    });
  }

  ElevatedButton streambutton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          _serviceEnabled = await location.serviceEnabled();
          if (!_serviceEnabled) {
            _serviceEnabled = await location.requestService();
            if (!_serviceEnabled) return;
          }
          try {
            _permissionGranted = await location.hasPermission();
            if (_permissionGranted == PermissionStatus.denied) {
              _permissionGranted = await location.requestPermission();
              if (_permissionGranted != PermissionStatus.granted) {
                showMyDialog(
                    context,
                    "Permission ERROR",
                    "Die App besitzt momentan nicht die Berechtigungen die sie benötigt!",
                    "Damit Sie den vollen Funktionsumfang der App nutzen können, erlauben sie der App in den Einstellungen Zugriff auf ihre Standortdaten!");
                return;
              }
            }
          } catch (err) {
            showMyDialog(
                context,
                "ERROR",
                "Ein Fehler bei der Abfrage der Berechtigung ist aufgetreten!",
                "$err");
          }

          if (_isListenLocation) {
            setState(() {
              _isListenLocation = false;
              buttontext = const Text('Start listening Location');
              _s.cancel();
            });
          } else {
            setState(() {
              _isListenLocation = true;
              streamsub();
              buttontext = const Text('Stop listening Location');
            });
          }
        },
        child: buttontext);
  }

  StreamBuilder stream(BuildContext context) {
    return StreamBuilder(
        stream: location.onLocationChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            var data = snapshot.data as LocationData;
            return Text('Location: ${data.latitude}/${data.longitude}');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
