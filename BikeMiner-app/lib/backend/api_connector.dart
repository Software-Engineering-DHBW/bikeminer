import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class APIConnector {
  String _access_token = "";
  final _server = "192.168.2.147";
  final _port = "8000";
  String _username = "";
  String _password = "";
  int _tourNumber = 0;

  /// logout
  void logout() {
    _username = "";
    _password = "";
    _access_token = "";
    if (_tourNumber < 0) {
      _tourNumber = 0;
    }
  }

  /// get username
  String getusername() {
    return _username;
  }

  /// login in the API and get a token
  Future<Map<String, dynamic>> getlogintoken(username, password) async {
    _username = username;
    _password = password;
    Map<String, dynamic> formMap = {
      "grant_type": "",
      "username": "$username",
      "password": "$password",
      "scope": "",
      "client_id": "",
      "client_secret": ""
    };
    final response = await post(Uri.parse('http://$_server:$_port/token'),
        body: formMap,
        headers: {
          "accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> res = {
        "statusCode": response.statusCode,
      };
      _access_token = json.decode(response.body)['access_token'];
      return res;
    } else {
      Map<String, dynamic> res = {
        "statusCode": response.statusCode,
        "detail": json.decode(response.body)["detail"]
      };
      return res;
    }
  }

  /// Benutzer erstellen
  Future<Map<String, dynamic>> createUser(username, email, password) async {
    var data =
        '{"userName": "$username","email": "$email","password": "$password"}';

    final response = await post(
        Uri.parse('http://$_server:$_port/users/create'),
        body: data,
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> res = {
        "statusCode": response.statusCode,
      };
      return res;
    } else {
      Map<String, dynamic> res = {
        "statusCode": response.statusCode,
        "detail": json.decode(response.body)["detail"]
      };
      return res;
    }
  }

  /// send coordinates to the server
  Future<void> sendcoordinates(lat, long, time) async {
    var data =
        '{"tourID": 1,"tourNumber": $_tourNumber,"longitude": $long,"latitude": $lat, "datetime": "$time"}';
    _tourNumber += 1;

    final response = await post(
        Uri.parse('http://$_server:$_port/coordinates/create'),
        body: data,
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $_access_token"
        });
    debugPrint("${response.statusCode}${response.body}");

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      getlogintoken(_username, _password);
    }
  }

  /// tells the server to calculate the las ride
  Future<void> stopriding() async {
    final response = await post(
        Uri.parse(
            'http://$_server:$_port/coordinates/calculateDistance?tour_id=1'),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_access_token"
        });

    if (response.statusCode == 200) {
      _tourNumber = 0;
      return;
    } else if (response.statusCode == 401) {
      getlogintoken(_username, _password).then((value) async {
        final response = await post(
            Uri.parse(
                'http://$_server:$_port/coordinates/calculateDistance?tour_id=1'),
            headers: {
              "accept": "application/json",
              "Authorization": "Bearer $_access_token"
            });
      });
    }
    _tourNumber = 0;
  }

  ///Alle Benutzerdaten
  Future<double> getbalance() async {
    // final response = await get(Uri.parse('http://10.0.2.2:8000/users/all'));
    final response = await post(
        Uri.parse('http://$_server:$_port/users/get_balance'),
        body: '',
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_access_token"
        });

    debugPrint("${response.statusCode}${response.body}");
    // ignore: unused_local_variable
    if (response.statusCode == 200) {
      return json.decode(response.body)["coins"];
    } else {
      // throw Exception('Failed to fetch');
      return 0;
    }
  }

  ///Historie-Daten
  Future<List> getHistory() async {
    // final response = await get(Uri.parse('http://10.0.2.2:8000/history/Hallo'));
    final response = await get(Uri.parse('http://$_server:$_port/history/me'),
        // body: '',
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_access_token"
        });

    debugPrint("${response.statusCode}${response.body}");
    // ignore: unused_local_variable
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body);
    } else {
      return [];
      // throw Exception('Failed to fetch');
      //return "";
    }
  }
}
