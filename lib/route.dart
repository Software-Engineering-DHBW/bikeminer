import 'package:flutter/material.dart';
// importing our pages into our route.dart
import 'package:bikeminer/pages/map.dart';
import 'package:bikeminer/pages/login.dart';
import 'package:bikeminer/pages/registration.dart';
import 'package:bikeminer/pages/wallet.dart';

// variable for our route names
const String loginPage = 'login';
const String registrationPage = 'regist';
const String mapPage = 'map';
const String walletPage = 'wallet';

void login() {}

// controller function with switch statement to control page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case loginPage:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case mapPage:
      return MaterialPageRoute(builder: (context) => const Map());
    case registrationPage:
      return MaterialPageRoute(builder: (context) => const RegistrationPage());
    case walletPage:
      return MaterialPageRoute(
          builder: (BuildContext context) => const WalletPage());
    default:
      throw ('this route name does not exist');
  }
}
