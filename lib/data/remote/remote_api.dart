import 'package:dio/dio.dart';
import 'package:flutterapp/data/model/model_entity.dart';
import 'package:retrofit/retrofit.dart';

part 'remote_api.g.dart';

@RestApi(baseUrl: "https://github-trending-api.now.sh")
abstract class ApiClient {
  factory ApiClient(Dio dio) {
    dio.options = BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
    return _ApiClient(dio);
  }

  @GET("/repositories")
  Future<List<ModelEntity>> getRepositories();
}
