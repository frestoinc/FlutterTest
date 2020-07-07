import 'package:dartz/dartz.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/data/repository/remote/remote_repository.dart';

import 'data_manager.dart';

class DataManagerImpl implements DataManager {
  final RemoteRepository remoteRepo;

  const DataManagerImpl(this.remoteRepo);

  @override
  Future<Either<Exception, List<ModelEntity>>> getRepositories() {
    return remoteRepo.getRepositories();
  }
}
