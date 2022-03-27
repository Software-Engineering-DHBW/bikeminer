import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Class to Controll the Flutter Secure Storage
///
/// Class to store data in sharedPreferences
/// which encrypt keys and values
/// It handles AES encryption to generate a secret key encrypted with RSA and stored in KeyStore.
class StorageAdapter {
  /// Definition of the Storage and the AccountNameController
  final _storage = const FlutterSecureStorage();

  /// Lists of Elements
  List<_SecItem> _items = [];
  final List<String> _defaultsettings = ["Username", "Password"];

  /// Search in the _SecItem List _items after the key and return the value
  String getElementwithkey(String key) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].key == key) {
        return _items[i].value;
      }
    }
    return "";
  }

  /// read all Elements in the Storage and load them in the List _items
  Future<bool> readAll() async {
    debugPrint("StorageAdapter init!");
    _items = [];
    for (int i = 0; i < _defaultsettings.length; i++) {
      _SecItem? e = await readFromSecureStorage(_defaultsettings[i]);
      while (e != null) {
        _items.add(_SecItem(e.key, e.value));
      }
    }
    return true;
  }

  /// Update Element in the Flutter Storage and in the private Variablelist _items
  void updateElementwithKey(String key, String value) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].key == key) {
        var newitem = _SecItem(key, value);
        _items[i] = _SecItem(key, value);
        writeToSecureStorage(newitem);
        break;
      }
    }
  }

  /// deletes the items in the storage
  void deleteAll() async {
    await _storage.deleteAll(aOptions: _getAndroidOptions());
    readAll();
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  /// Write Element to the Storage
  Future<void> writeToSecureStorage(_SecItem secitem) async {
    await _storage.write(
        key: secitem.key,
        value: secitem.value,
        // iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
  }

  /// read Element with key from Flutter Storage
  Future<_SecItem?> readFromSecureStorage(String key) async {
    String? secret =
        await _storage.read(key: key, aOptions: _getAndroidOptions());
    if (secret == null) {
      debugPrint("readfromSecureStorage: secret = $secret");
      secret = "";
      return null;
    } else {
      return _SecItem(key, secret.toString());
    }
  }
}

/// Element for better usage
class _SecItem {
  _SecItem(this.key, this.value);

  final String key;
  final String value;
}
