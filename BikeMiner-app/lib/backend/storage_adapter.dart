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
  final _accountNameController =
      TextEditingController(text: 'flutter_secure_storage_service');

  /// Lists of Elements
  List<_SecItem> _items = [];
  final List<_SecItem> _defaultsettings = [];

  /// read all Elements in the Storage and load them in the List _items
  Future<bool> readAll() async {
    debugPrint("StorageAdapter init!");
    _items = [];
    _initDefaultSettings();
    for (int i = 0; i < _defaultsettings.length; i++) {
      _SecItem? e = await readFromSecureStorage(_defaultsettings[i].key);
      while (e == null) {
        writeToSecureStorage(_defaultsettings[i]);
        debugPrint("Write to Storage");
        e = await readFromSecureStorage(_defaultsettings[i].key);
      }
      _items.add(_SecItem(e.key, e.value));
    }
    debugPrint("StorageAdapter init ended!");
    return true;
  }

  /// Search in the _SecItem List _items after the key and return the value
  String getElementwithkey(String key) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].key == key) {
        return _items[i].value;
      }
    }
    return "";
  }

  /// Update Element in the Flutter Storage and in the private Variablelist _items
  Future<void> updateElementwithKey(String key, String value) async {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].key == key) {
        var newitem = _SecItem(key, value);
        _items[i] = _SecItem(key, value);
        await writeToSecureStorage(newitem);
        return;
      }
    }
  }

  /// set the default Settings
  void _initDefaultSettings() {
    _defaultsettings.add(_SecItem("Username", ""));
    _defaultsettings.add(_SecItem("Password", ""));
  }

  IOSOptions _getIOSOptions() => IOSOptions(
        accountName: _getAccountName(),
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  String? _getAccountName() =>
      _accountNameController.text.isEmpty ? null : _accountNameController.text;

  /// Write Element to the Storage
  Future<void> writeToSecureStorage(_SecItem secitem) async {
    await _storage.write(
        key: secitem.key,
        value: secitem.value,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
  }

  /// read Element with key from Flutter Storage
  Future<_SecItem?> readFromSecureStorage(String key) async {
    String? secret = await _storage.read(
        key: key, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
    if (secret == null) {
      debugPrint("readfromSecureStorage: secret = $secret");
      secret = "";
      return null;
    } else {
      return _SecItem(key, secret.toString());
    }
  }

  /// deletes the items in the storage
  void deleteAll() async {
    await _storage.deleteAll(aOptions: _getAndroidOptions());
    readAll();
  }
}

/// Element for better usage
class _SecItem {
  _SecItem(this.key, this.value);

  final String key;
  final String value;
}
