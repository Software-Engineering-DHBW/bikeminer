import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class APIConnector {
  String _accesstoken = "";
  // TODO: change the IP-Address when necessary
  final _server = "192.168.2.147";
  final _port = "8000";
  String _username = "";
  String _password = "";
  int _tourNumber = 0;

  /// logout
  void logout() {
    _username = "";
    _password = "";
    _accesstoken = "";
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
    Response response;
    try {
      response = await post(Uri.parse('http://$_server:$_port/token'),
          body: formMap,
          headers: {
            "accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          });
    } catch (e) {
      Map<String, dynamic> res = {
        "statusCode": 503,
        "detail": "Server nicht erreichbar"
      };
      return res;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> res = {
        "statusCode": response.statusCode,
      };
      _accesstoken = json.decode(response.body)['access_token'];
      return res;
    } else {
      Map<String, dynamic> res = {
        "statusCode": response.statusCode,
        "detail": json.decode(response.body)["detail"]
      };
      return res;
    }
  }

  /// create user
  Future<Map<String, dynamic>> createUser(username, email, password) async {
    var data =
        '{"userName": "$username","email": "$email","password": "$password"}';

    Response response;
    try {
      response = await post(Uri.parse('http://$_server:$_port/users/create'),
          body: data,
          headers: {
            "accept": "application/json",
            "Content-Type": "application/json"
          });
    } catch (e) {
      Map<String, dynamic> res = {
        "statusCode": 503,
        "detail": "Server nicht erreichbar"
      };
      return res;
    }

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
  Future<int> sendcoordinates(lat, long, time) async {
    var data =
        '{"tourID": 1,"tourNumber": $_tourNumber,"longitude": $long,"latitude": $lat, "datetime": "$time"}';
    _tourNumber += 1;

    Response response;
    try {
      response = await post(
          Uri.parse('http://$_server:$_port/coordinates/create'),
          body: data,
          headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $_accesstoken"
          }).timeout(const Duration(seconds: 10));
    } catch (e) {
      return 503;
    }

    debugPrint("${response.statusCode}${response.body}");

    if (response.statusCode == 401) {
      getlogintoken(_username, _password);
    }
    return response.statusCode;
  }

  /// tells the server to calculate the las ride
  Future<int> stopriding() async {
    Response response;
    try {
      response = await post(
          Uri.parse(
              'http://$_server:$_port/coordinates/calculateDistance?tour_id=1'),
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $_accesstoken"
          });
    } catch (e) {
      return 503;
    }

    if (response.statusCode == 401) {
      getlogintoken(_username, _password).then((value) async {
        response = await post(
            Uri.parse(
                'http://$_server:$_port/coordinates/calculateDistance?tour_id=1'),
            headers: {
              "accept": "application/json",
              "Authorization": "Bearer $_accesstoken"
            });
      });
    }
    _tourNumber = 0;
    return response.statusCode;
  }

  ///Alle Benutzerdaten
  Future<double> getbalance() async {
    Response response;
    try {
      response = await post(
          Uri.parse('http://$_server:$_port/users/get_balance'),
          body: '',
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $_accesstoken"
          });
    } catch (e) {
      return 0;
    }
    if (response.statusCode == 200) {
      return json.decode(response.body)["coins"];
    } else {
      return 0;
    }
  }

  ///Historie-Daten
  Future<List> getHistory() async {
    Response response;
    try {
      response = await get(Uri.parse('http://$_server:$_port/history/me'),
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $_accesstoken"
          });
    } catch (e) {
      return [];
    }
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return [];
    }
  }
}
