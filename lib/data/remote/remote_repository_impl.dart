import 'package:dartz/dartz.dart';
import 'package:flutterapp/data/api/remote_api.dart';
import 'package:flutterapp/data/remote/remote_repository.dart';
import 'package:flutterapp/model/model_entity.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final ApiClient _apiClient;

  const RemoteRepositoryImpl(this._apiClient);

  @override
  Future<Either<Exception, List<ModelEntity>>> getRepositories() {
    return _apiClient.getRepositories();
  }
}
