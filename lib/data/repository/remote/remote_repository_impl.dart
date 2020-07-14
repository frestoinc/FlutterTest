import 'package:dartz/dartz.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/data/repository/remote/remote_repository.dart';
import 'package:flutterapp/services/remote_api.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final ApiClient _apiClient;

  const RemoteRepositoryImpl(this._apiClient);

  @override
  Future<Either<Exception, List<ModelEntity>>> getRepositories() {
    return _apiClient.getRepositories();
  }
}
