import 'package:bikeminer/backend/api_connector.dart';
import 'package:flutter/material.dart';
import 'package:bikeminer/route.dart' as route;
import 'package:bikeminer/backend/storage_adapter.dart';

/// SplashScreen
class LoadingPage extends StatefulWidget {
  final StorageAdapter _sa;
  final APIConnector _api;
  const LoadingPage(this._sa, this._api, {Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late BuildContext _context;

  @override
  void initState() {
    widget._sa.readAll().then((ready) {
      var username = widget._sa.getElementwithkey("Username");
      if (username == "") {
        Navigator.pop(_context);
        Navigator.pushNamed(_context, route.loginPage);
      } else {
        var password = widget._sa.getElementwithkey("Password");
        debugPrint("Logindata are available in Storage!");
        debugPrint("Try to Login!");

        widget._api
            .getlogintoken(username, password)
            .then((value) {
              var statuscode = value["statusCode"];
              if (statuscode == 200) {
                debugPrint("Loged in!");
                Navigator.pop(context);
                Navigator.pushNamed(context, route.mapPage);
              } else {
                debugPrint("Login failed!");
                widget._sa.deleteAll();
                Navigator.pop(_context);
                Navigator.pushNamed(_context, route.loginPage);
              }
            })
            .timeout(const Duration(seconds: 5))
            .catchError((onError) {
              debugPrint("Login failed on ERROR!");
              debugPrint("Server might not be available!");
              widget._sa.deleteAll();
              Navigator.pop(_context);
              Navigator.pushNamed(_context, route.loginPage);
            });
      }
    }).timeout(const Duration(seconds: 5));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green,
        body: SafeArea(
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "BikeMiner",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
