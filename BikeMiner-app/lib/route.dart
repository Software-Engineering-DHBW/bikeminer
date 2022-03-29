import 'package:bikeminer/pages/rides.dart';
import 'package:bikeminer/pages/wallet.dart';
import 'package:flutter/material.dart';

import 'package:bikeminer/backend/api_connector.dart';
import 'package:bikeminer/pages/loading.dart';
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
const String ridesPage = 'rides';
StorageAdapter _sa = StorageAdapter();
APIConnector _api = APIConnector();

/// controller function with switch statement to control page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case loadingPage:
      return MaterialPageRoute(builder: (context) => LoadingPage(_sa, _api));
    case loginPage:
      return MaterialPageRoute(builder: (context) => LoginPage(_sa, _api));
    case mapPage:
      return MaterialPageRoute(builder: (context) => Map(_sa, _api));
    case walletPage:
      return MaterialPageRoute(builder: (context) => WalletPage(_api));
    case ridesPage:
      return MaterialPageRoute(builder: (context) => RidesPage(_api));
    case registrationPage:
      return MaterialPageRoute(builder: (context) => RegistrationPage(_api));
    default:
      throw ('this route name does not exist');
  }
}
