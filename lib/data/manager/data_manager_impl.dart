import 'package:dartz/dartz.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/data/entities/user.dart';
import 'package:flutterapp/data/repository/local/preference/local_preference.dart';
import 'package:flutterapp/data/repository/remote/remote_repository.dart';

import 'data_manager.dart';

class DataManagerImpl implements DataManager {
  final RemoteRepository _remoteRepo;
  final LocalPreference _localPref;

  const DataManagerImpl(this._remoteRepo, this._localPref);

  @override
  Future<Either<Exception, List<ModelEntity>>> getRepositories() {
    return _remoteRepo.getRepositories();
  }

  @override
  Future<Either<Exception, bool>> deleteCredentials() {
    return _localPref.deleteCredentials();
  }

  @override
  Future<Either<Exception, User>> readCredentials() {
    return _localPref.readCredentials();
  }

  @override
  Future<Either<Exception, bool>> saveCredentials(User user) {
    return _localPref.saveCredentials(user);
  }

  @override
  Future<bool> validCredentials() {
    return _localPref.validCredentials();
  }
}
