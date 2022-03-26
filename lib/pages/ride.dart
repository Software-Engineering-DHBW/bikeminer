import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RidePage extends StatefulWidget {
  const RidePage({Key? key}) : super(key: key);

  @override
  State<RidePage> createState() => _RidePageState();
}

/// RidePageState-Widget, liefert alle Informationen zur jeweiligen vergangen Fahrt, in Form von JSON
class _RidePageState extends State<RidePage> {

  List _items = [];

  /// Lese inhalt aus der hinterlegten JSON-Datei
  Future<void> readJson() async {
    /// Lade den JSON-String von jeweiligenm Datei-Pfad
    final String response = await rootBundle.loadString('assets/sample.json');
    /// Dekodiere das JSON-Format
    final data = await json.decode(response);

    setState(() {
      _items = data["items"];
    });
  }
  ///
  @override
  Widget build(BuildContext context) {
    const title = 'Ride 1';


    return MaterialApp(
        title: title,
        home: Scaffold(
          appBar: AppBar(backgroundColor: const Color.fromARGB(255, 30, 134, 49), title: const Text(title,style: TextStyle(color: Colors.white),),
            automaticallyImplyLeading: false,
            leading: IconButton (
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
              ElevatedButton(
                child: const Text('Load Data'),
                onPressed: readJson,
              ),
              // Display the data loaded from sample.json
              _items.isNotEmpty
              ? Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Text(_items[index]["id"]),
                      title: Text(_items[index]["name"]),
                      subtitle: Text(_items[index]["description"]),
                    ),
                  );
                },
                ),
              )
              : Container()
            ],
          ),
        ),
      ),
    );
  }
}

