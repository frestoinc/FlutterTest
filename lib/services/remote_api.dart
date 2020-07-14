import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<Either<Exception, List<ModelEntity>>> getRepositories() async {
    try {
      final _response = await http.get(WEB_API + WEB_API_TOKEN);
      final _bodyList = jsonDecode(_response.body) as List;
      return Right(_bodyList.map((e) => ModelEntity.fromJson(e)).toList());
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
