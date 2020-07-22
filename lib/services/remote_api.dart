import 'dart:async';
import 'dart:convert';

import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/extension/response.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<Response> getRepositories() async {
    try {
      final _response = await http
          .get(WEB_API + WEB_API_TOKEN)
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw TimeoutException(null, Duration(seconds: 10));
      });
      final _bodyList = jsonDecode(_response.body) as List;
      return Response<List<ModelEntity>>.success(
          _bodyList.map((e) => ModelEntity.fromJson(e)).toList());
    } on Exception catch (e) {
      return Response<Exception>.error(e);
    }
  }
}
