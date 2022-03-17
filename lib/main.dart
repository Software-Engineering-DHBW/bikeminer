import 'package:flutter/material.dart';
import 'package:bikeminer/route.dart' as route;
// import 'package:flutter_application_1/pages/loginscreen.dart';
// import 'package:flutter_application_1/pages/test_gps_page.dart';
// import 'package:flutter_application_1/pages/map.dart';

void main() {
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   /// This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'BikeMiner',
//         theme: ThemeData(
//           // This is the theme of your application.
//           //
//           // Try running your application with "flutter run". You'll see the
//           // application has a blue toolbar. Then, without quitting the app, try
//           // changing the primarySwatch below to Colors.green and then invoke
//           // "hot reload" (press "r" in the console where you ran "flutter run",
//           // or simply save your changes to "hot reload" in a Flutter IDE).
//           // Notice that the counter didn't reset back to zero; the application
//           // is not restarted.
//           primarySwatch: Colors.green,
//         ),
//         home:
//             const LoginPage() //const Map(title: 'BikeMiner'), // const MyHomePage(title: 'BikeMiner'), //
//         );
//   }
// }

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
      initialRoute: route.loginPage,
    );
    // home: const LoginPage());
  }
}
