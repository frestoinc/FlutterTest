import 'package:flutterapp/data/model/model_entity.dart';
import 'package:flutterapp/data/remote/remote_api.dart';

abstract class RemoteRepository {
  Future<List<ModelEntity>> getRepositories();
}

class RemoteRepositoryImpl implements RemoteRepository {
  ApiClient client;

  RemoteRepositoryImpl(ApiClient client) {
    this.client = client;
  }

  @override
  Future<List<ModelEntity>> getRepositories() {
    return client.getRepositories();
  }
}
