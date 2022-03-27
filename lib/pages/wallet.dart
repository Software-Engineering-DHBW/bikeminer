import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  List _items = [];

  @override
  void initState() {
    readJson();
    super.initState();
  }

  /// Lese inhalt aus der hinterlegten JSON-Datei
  Future<void> readJson() async {
    /// Lade den JSON-String von jeweiligenm Datei-Pfad
    final String response = await rootBundle.loadString('assets/walletSample.json');

    /// Dekodiere das JSON-Format
    final data = await json.decode(response);

    setState(() {
      _items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wallet",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 30, 134, 49),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
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
                            leading:Column(
                              children: [
                                const Text("User: "),
                                Text(_items[index]["userName"].toString())

                              ],
                            ),
                            title:Column(
                              children: [
                                const Text("Coins: "),
                                Text( _items[index]["email"].toString())

                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Text("Datum: " + _items[index]["coins"].toString()),
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
    );
  }
}
