import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class APIConnector {
  String _access_token = "";
  final _server = "192.168.2.147";
  final _port = "8000";
  String _username = "";

  bool hasaccestoken() {
    if (_access_token != "") {
      return true;
    }
    return false;
  }

  void logout() {
    _username = "";
    _access_token = "";
  }

  String getusername() {
    return _username;
  }

  Future<Map<String, dynamic>> getlogintoken(username, password) async {
    _username = username;
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
}
