import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterapp/data/entities/user.dart';
import 'package:flutterapp/data/repository/local/preference/local_preference.dart';
import 'package:flutterapp/extension/constants.dart';

class LocalPreferenceImpl implements LocalPreference {
  final FlutterSecureStorage _storage;

  const LocalPreferenceImpl(this._storage);

  @override
  Future<Either<Exception, bool>> deleteCredentials() async {
    try {
      await _storage.delete(key: USER_PREF_KEY);
      return Right(true);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, User>> readCredentials() async {
    try {
      final _response = await _storage.read(key: USER_PREF_KEY);
      return Right(User.fromJson(jsonDecode(_response)));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, bool>> saveCredentials(User user) async {
    try {
      await _storage.write(
          key: USER_PREF_KEY, value: jsonEncode(user.toJson()));
      return Right(true);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
