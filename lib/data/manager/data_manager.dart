import 'package:flutterapp/data/model/model_entity.dart';
import 'package:flutterapp/data/remote/remote_repository.dart';

abstract class DataManager extends RemoteRepository {}

class DataManagerImpl implements DataManager {
  RemoteRepository remoteRepository;

  DataManagerImpl(RemoteRepository remote) {
    this.remoteRepository = remote;
  }

  @override
  Future<List<ModelEntity>> getRepositories() {
    return remoteRepository.getRepositories();
  }
}
