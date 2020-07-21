import 'package:flutterapp/extension/response.dart';
import 'package:flutterapp/services/remote_api.dart';

abstract class RemoteRepository {
  Future<Response> getRepositories();
}

class RemoteRepositoryImpl implements RemoteRepository {
  final ApiClient _apiClient;

  const RemoteRepositoryImpl(this._apiClient);

  @override
  Future<Response> getRepositories() => _apiClient.getRepositories();
}
