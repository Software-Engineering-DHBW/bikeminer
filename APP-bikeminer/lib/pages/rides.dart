import 'dart:convert';
import 'package:bikeminer/backend/api_connector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timelines/timelines.dart';

class RidesPage extends StatefulWidget {
  final APIConnector _api;
  const RidesPage(this._api, {Key? key}) : super(key: key);

  @override
  State<RidesPage> createState() => _RidesPageState();
}

/// Stateful Widget "RidesPageState" stellt das Grundgerüst der Seite zur gefahrenen Strecken anhand einer Timeline dar
class _RidesPageState extends State<RidesPage> {
  List _items = [];
  @override
  void initState() {
    readJson();
    super.initState();
  }

  /// Lese inhalt aus der hinterlegten JSON-Datei
  Future<void> readJson() async {
    /// Lade den JSON-String von jeweiligenm Datei-Pfad
    final String response = await rootBundle.loadString('assets/sample.json');

    /// Dekodiere das JSON-Format
    final data = await json.decode(response);

    setState(() {
      _items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Rides';
    return MaterialApp(
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
                                  const Text("Strecke: "),
                                  Text(_items[index]["userName"].toString())
                                ],
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Startzeit: "),
                                  Text(_items[index]["email"].toString())
                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  Text("Coins: " +
                                      _items[index]["coins"].toString()),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Text("Dauer: "),
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
    /*///Erstellung der Timeline (Zeitlinie teilt den Body der Seite in zwei Hälften) mit bestimmten Stil
    return Timeline.tileBuilder(builder: TimelineTileBuilder.fromStyle(
      contentsAlign: ContentsAlign.alternating,
      contentsBuilder: (context, index) => Padding(
        ///Skalierung/Abstand der Seitenränder
        padding: const EdgeInsets.all(24.0),
        /// Erstellung von Boxen (mit Inhalt) zu den markierten Zeitpunkten auf der Timeline
        child: SizedBox.expand(
          /// Die erstellten Boxen werden als klickbare Cards definiert
          child: Card(
            color: Colors.green,
            /// Per Klick auf die jeweilige Card öffnet sich die "RidePage", die genauere Informationen zur jeweiligen Fahrt liefert
            child: InkWell(
              onTap: (){
                  /// Rufe die "RidePage"-Seite auf
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const RidePage(),
                  ),
                  );
                },
              child: Text('Ride $index'),
              ),
            ),
          ),
        ),
      itemCount: 10,
      ),
    );
  }

}
*/

/*class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date = now.hour.toString() + ":" + now.minute.toString() + ":" + now.second.toString();
    return SizedBox(
      height: 240,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text(""),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/

