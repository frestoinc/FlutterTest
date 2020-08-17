import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterapp/data/entities/user.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/extension/response.dart';

abstract class LocalPreference {
  Future<Response> saveCredentials(User user);

  Future<Response> readCredentials();

  Future<Response> deleteCredentials();

  Future<bool> validCredentials();
}

class LocalPreferenceImpl implements LocalPreference {
  final FlutterSecureStorage _storage;

  const LocalPreferenceImpl(this._storage);

  @override
  Future<Response> deleteCredentials() async {
    try {
      await _storage.delete(key: USER_PREF_KEY);
      return Response<bool>.success(true);
    } on Exception catch (e) {
      return Response<Exception>.error(e);
    }
  }

  @override
  Future<Response> readCredentials() async {
    try {
      final _response = await _storage.read(key: USER_PREF_KEY);
      return Response<String>.success(
          User.fromJson(jsonDecode(_response)).emailAddress);
    } on Exception catch (e) {
      return Response<Exception>.error(e);
    }
  }

  @override
  Future<Response> saveCredentials(User user) async {
    try {
      await _storage.write(
          key: USER_PREF_KEY, value: jsonEncode(user.toJson()));
      return Response<bool>.success(true);
    } on Exception catch (e) {
      return Response<Exception>.error(e);
    }
  }

  @override
  Future<bool> validCredentials() async {
    try {
      final _response = await _storage.read(key: USER_PREF_KEY);
      return _response?.isNotEmpty ?? false;
    } on Exception catch (_) {
      return false;
    }
  }
}
