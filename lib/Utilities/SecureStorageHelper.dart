import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:safe/Models/User.dart';

class SecureStorageHelper {
  static final _storage = FlutterSecureStorage();

  static Future setStringValue(String _key, String _value) async {
    _storage.write(key: _key, value: _value);
  }

  static Future<String?> getStringValue(String _key) async {
    return _storage.read(key: _key);
  }

  static Future setListString(String _key, List<String> _list) async {
    String _value = json.encode(_list);
    _storage.write(key: _key, value: _value);
  }

  static Future<List<String>?> getListString(String _key) async {
    String? _value = await _storage.read(key: _key);
    return _value == null ? null : List<String>.from(json.decode(_value));
  }

  static Future setDateValue(String _key, DateTime _datetime) async {
    final _dt = _datetime.toIso8601String();
    _storage.write(key: _key, value: _dt);
  }

  static Future<DateTime?> getDateValue(String _key) async {
    final _dt = await _storage.read(key: _key);
    return _dt == null ? null : DateTime.parse(_dt);
  }

  static Future<bool> containsKey(String key) async {
    return _storage.containsKey(key: key);
  }

  static removeValue(String key) async {
    _storage.delete(key: key);
  }

  static removeAll() async {
    _storage.deleteAll();
  }
}
