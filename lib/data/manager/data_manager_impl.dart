import 'package:dartz/dartz.dart';
import 'package:flutterapp/data/remote/remote_repository.dart';
import 'package:flutterapp/model/model_entity.dart';

import 'data_manager.dart';

class DataManagerImpl implements DataManager {
  final RemoteRepository _remoteRepo;

  const DataManagerImpl(this._remoteRepo);

  @override
  Future<Either<Exception, List<ModelEntity>>> getRepositories() {
    return _remoteRepo.getRepositories();
  }
}
