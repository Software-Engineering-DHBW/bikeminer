import 'package:bikeminer/backend/api_connector.dart';
import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  final APIConnector _api;
  const WalletPage(this._api, {Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  APIConnector n = APIConnector();
  List _items = [];

  //late var text = "";

  void getR() {
    n.getusersall().then((value){
      setState((){
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
            _items.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Column(
                        children: [
                          const Text("User: "),
                          Text(_items[index]["userName"].toString())
                        ],
                      ),
                      title: Column(
                        children: [
                          const Text("Coins: "),
                          Text(_items[index]["coins"].toString())
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          Text("Email: " +
                              _items[index]["email"].toString()),
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