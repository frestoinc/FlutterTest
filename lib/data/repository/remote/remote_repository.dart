import 'package:dartz/dartz.dart';
import 'package:flutterapp/data/entities/model_entity.dart';

abstract class RemoteRepository {
  Future<Either<Exception, List<ModelEntity>>> getRepositories();
}
