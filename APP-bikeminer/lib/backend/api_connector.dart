import 'dart:convert';
import 'package:http/http.dart' as http;

class APIConnector {
  final _server_url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=mannheim&format=json");
  var client = http.Client();

  bool _logedin = false;
  String _username = "";
  String _password = "";

  bool postRequest() {
    return true;
  }

  void getRequest() async {
    http.Response response = await client.get(_server_url);
    var body = response.body;

    var object = json.decode(body);

    for (int i = 0; i < object.length; i++) {
      print(object[i]);
    }
    // return object;
  }

  bool islogedin() {
    return _logedin;
  }

  bool login(username, password) {
    if (_logedin) {
      return true;
    } else {
      return false;
    }
    return false;
  }
}
