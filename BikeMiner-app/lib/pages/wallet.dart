import 'package:bikeminer/backend/api_connector.dart';
import 'package:flutter/material.dart';

/// for showing the user the actual coints
class WalletPage extends StatefulWidget {
  final APIConnector _api;
  const WalletPage(this._api, {Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double _items = 0;

  void getR() {
    widget._api.getbalance().then((value) {
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

            Card(
              child: ListTile(
                title: Column(
                  children: [const Text("Coins: "), Text(_items.toString())],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
