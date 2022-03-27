import 'package:bikeminer/backend/api_connector.dart';
import 'package:bikeminer/main.dart';
import 'package:flutter/material.dart';
import 'package:bikeminer/pages/map.dart';
import 'package:bikeminer/pages/login.dart';
import 'package:bikeminer/pages/registration.dart';

import 'backend/storage_adapter.dart';

// variable for our route names
const String loadingPage = 'load';
const String loginPage = 'login';
const String registrationPage = 'regist';
const String mapPage = 'map';
const String walletPage = 'wallet';
StorageAdapter _sa = StorageAdapter();
APIConnectorclass _api = APIConnectorclass();

// controller function with switch statement to control page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case loadingPage:
      return MaterialPageRoute(builder: (context) => LoadingPage(_sa));
    case loginPage:
      return MaterialPageRoute(builder: (context) => LoginPage(_sa));
    case mapPage:
      return MaterialPageRoute(builder: (context) => Map(_sa));
    case registrationPage:
      return MaterialPageRoute(builder: (context) => const RegistrationPage());
    default:
      throw ('this route name does not exist');
  }
}
