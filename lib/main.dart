import 'package:bikeminer/backend/storage_adapter.dart';
import 'package:flutter/material.dart';
import 'package:bikeminer/route.dart' as route;

void main() {
  runApp(const MyApp());
}

/// SplashScreen
class LoadingPage extends StatefulWidget {
  final StorageAdapter _sa;
  const LoadingPage(this._sa, {Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  // final StorageAdapter _sa = StorageAdapter();
  late String? _password;
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

        try {
          // TODO: LOGIN to API
          debugPrint("Loged in!");
        } catch (e) {
          debugPrint("Login failed!");
          widget._sa.deleteAll();
          Navigator.pop(_context);
          Navigator.pushNamed(_context, route.loginPage);
        }
      }
    }).timeout(const Duration(seconds: 3));
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
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                // Image.asset(
                //   "assets/bikeminer_icon.png",
                //   width: 240,
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BikeMiner',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme(
            primary: Colors.white,
            onPrimary: Colors.white,
            brightness: Brightness.light,
            secondary: Colors.green,
            onSecondary: Colors.green,
            error: Colors.red,
            onError: Colors.red,
            background: Colors.green,
            onBackground: Colors.green,
            surface: Colors.white,
            onSurface: Colors.white),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 0, foregroundColor: Colors.white),
        // primarySwatch: Colors.green,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 22.0, color: Colors.green),
          headline2: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: Colors.green,
          ),
          bodyText1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.blueAccent,
          ),
        ),
      ),
      onGenerateRoute: route.controller,
      initialRoute: route.loadingPage,
    );
    // home: const LoginPage());
  }
}
