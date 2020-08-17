import 'package:flutterapp/data/entities/user.dart';
import 'file:///C:/Users/r00t/Documents/Android/Projects/FlutterTest/lib/data/repository/local/local_preference.dart';
import 'package:flutterapp/data/repository/remote/remote_repository.dart';
import 'package:flutterapp/extension/response.dart';

abstract class DataManager implements RemoteRepository, LocalPreference {}

class DataManagerImpl implements DataManager {
  final RemoteRepository _remoteRepo;
  final LocalPreference _localPref;

  const DataManagerImpl(this._remoteRepo, this._localPref);

  @override
  Future<Response> getRepositories() => _remoteRepo.getRepositories();

  @override
  Future<Response> deleteCredentials() => _localPref.deleteCredentials();

  @override
  Future<Response> readCredentials() => _localPref.readCredentials();

  @override
  Future<Response> saveCredentials(User user) =>
      _localPref.saveCredentials(user);

  @override
  Future<bool> validCredentials() => _localPref.validCredentials();
}
