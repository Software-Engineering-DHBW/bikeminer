import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class APIConnector {
  String _access_token = "";
  final _server = "10.0.2.2";
  final _port = "8000";
  String _username = "";
  String _password = "";

  bool hasaccestoken() {
    if (_access_token != "") {
      return true;
    }
    return false;
  }

  void logout() {
    _username = "";
    _password = "";
    _access_token = "";
  }

  String getusername() {
    return _username;
  }

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
    debugPrint("${response.statusCode}${response.body}");
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
  ///Alle Benutzerdaten
  Future<List> getusersall() async {
    // var _request = Uri.parse("http://$_server:$_port/users/all");
    final response = await get(Uri.parse('http://10.0.2.2:8000/users/all'));
    // ignore: unused_local_variable
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch');
    }
  }
  ///Historie-Daten
  Future<List> getHistory() async {
    // var _request = Uri.parse("http://$_server:$_port/users/all");
    final response = await get(Uri.parse('http://10.0.2.2:8000/history/Hallo'));
    // ignore: unused_local_variable
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch');
      //return "";
    }

  }
}
