import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutterapp/model/model_entity.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<Either<Exception, List<ModelEntity>>> getRepositories() async {
    final _url = "https://github-trending-api.now.sh/repositories";
    try {
      final _response = await http.get(_url);
      final _bodyList = jsonDecode(_response.body) as List;
      return Right(_bodyList.map((e) => ModelEntity.fromJson(e)).toList());
    } catch (e) {
      return Left(e);
    }
  }
}
