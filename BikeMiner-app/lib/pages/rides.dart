import 'package:bikeminer/backend/api_connector.dart';
import 'package:flutter/material.dart';

class RidesPage extends StatefulWidget {
  final APIConnector _api;
  const RidesPage(this._api, {Key? key}) : super(key: key);

  @override
  State<RidesPage> createState() => _RidesPageState();
}

class _RidesPageState extends State<RidesPage> {
  List _items = [];

  void getR() {
    widget._api.getHistory().then((value) {
      setState(() {
        _items = value;
      });
    });
  }

  @override
  void initState() {
    getR();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Rides';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 30, 134, 49),
          title: const Text(
            title,
            style: TextStyle(color: Colors.white),
          ),

          /// Button in der AppBar um zur vorherigen Seite zu gelangen
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              /// Navigiere zur vorherigen Seite
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              // Display the data loaded from sample.json
              _items.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Column(
                                children: [
                                  const Text("Datum: "),
                                  Text(_items[index]["dateTime"].toString())
                                ],
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Gefahrene Strecke: "),
                                  Text("${_items[index]["distanceTraveled"]}km")
                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  Text("History-ID: " +
                                      _items[index]["historyID"].toString()),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  const Text("User-ID: "),
                                  Text(_items[index]["userID"].toString())
                                ],
                              ),
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
