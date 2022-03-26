import 'package:bikeminer/pages/ride.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class RidesPage extends StatefulWidget {
  const RidesPage({Key? key}) : super(key: key);

  @override
  State<RidesPage> createState() => _RidesPageState();
}

/// Stateful Widget "RidesPageState" stellt das Grundgerüst der Seite zur gefahrenen Strecken anhand einer Timeline dar
class _RidesPageState extends State<RidesPage> {
  @override
  Widget build(BuildContext context) {
    const title = 'Rides';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(backgroundColor: const Color.fromARGB(255, 30, 134, 49), title: const Text(title,style: TextStyle(color: Colors.white),),
          /// Button in der AppBar um zur vorherigen Seite zu gelangen
          automaticallyImplyLeading: false,
          leading: IconButton (
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              /// Navigiere zur vorherigen Seite
              Navigator.pop(context);
            },
          ),
        ),
        body: const RidingHistory(),
      ),
    );
  }
}
/// Der Inhalt (Body: "RidingHistory") der "RidesPageState"-Seite
class RidingHistory extends StatelessWidget {
  const RidingHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///Erstellung der Timeline (Zeitlinie teilt den Body der Seite in zwei Hälften) mit bestimmten Stil
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

