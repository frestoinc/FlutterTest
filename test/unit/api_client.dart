import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/extension/response.dart';
import 'package:flutterapp/services/remote_api.dart';
import 'package:mockito/mockito.dart';

class MockApiClient extends Mock implements ApiClient {}

final _body =
    '[\r\n{\r\n\"author\":\"openai\",\r\n\"name\":\"gpt-3\",\r\n\"avatar\":\"https:\/\/github.com\/openai.png\",\r\n\"url\":\"https:\/\/github.com\/openai\/gpt-3\",\r\n\"description\":\"GPT-3: Language Models are Few-Shot Learners\",\r\n\"stars\":4196,\r\n\"forks\":301,\r\n\"currentPeriodStars\":549,\r\n\"builtBy\":[\r\n{\r\n\"username\":\"nottombrown\",\r\n\"href\":\"https:\/\/github.com\/nottombrown\",\r\n\"avatar\":\"https:\/\/avatars1.githubusercontent.com\/u\/306655\"\r\n},\r\n{\r\n\"username\":\"8enmann\",\r\n\"href\":\"https:\/\/github.com\/8enmann\",\r\n\"avatar\":\"https:\/\/avatars0.githubusercontent.com\/u\/1021104\"\r\n},\r\n{\r\n\"username\":\"pranv\",\r\n\"href\":\"https:\/\/github.com\/pranv\",\r\n\"avatar\":\"https:\/\/avatars1.githubusercontent.com\/u\/8753078\"\r\n}\r\n]\r\n},\r\n{\r\n\"author\":\"forem\",\r\n\"name\":\"forem\",\r\n\"avatar\":\"https:\/\/github.com\/forem.png\",\r\n\"url\":\"https:\/\/github.com\/forem\/forem\",\r\n\"description\":\"For empowering community \uD83C\uDF31\",\r\n\"language\":\"Ruby\",\r\n\"languageColor\":\"#701516\",\r\n\"stars\":14121,\r\n\"forks\":2312,\r\n\"currentPeriodStars\":223,\r\n\"builtBy\":[\r\n{\r\n\"username\":\"benhalpern\",\r\n\"href\":\"https:\/\/github.com\/benhalpern\",\r\n\"avatar\":\"https:\/\/avatars0.githubusercontent.com\/u\/3102842\"\r\n},\r\n{\r\n\"username\":\"rhymes\",\r\n\"href\":\"https:\/\/github.com\/rhymes\",\r\n\"avatar\":\"https:\/\/avatars0.githubusercontent.com\/u\/146201\"\r\n},\r\n{\r\n\"username\":\"mstruve\",\r\n\"href\":\"https:\/\/github.com\/mstruve\",\r\n\"avatar\":\"https:\/\/avatars3.githubusercontent.com\/u\/1813380\"\r\n}\r\n]\r\n},\r\n{\r\n\"author\":\"vuejs\",\r\n\"name\":\"docs-next\",\r\n\"avatar\":\"https:\/\/github.com\/vuejs.png\",\r\n\"url\":\"https:\/\/github.com\/vuejs\/docs-next\",\r\n\"description\":\"Vue 3 core documentation\",\r\n\"language\":\"Vue\",\r\n\"languageColor\":\"#2c3e50\",\r\n\"stars\":141,\r\n\"forks\":28,\r\n\"currentPeriodStars\":53,\r\n\"builtBy\":[\r\n{\r\n\"username\":\"NataliaTepluhina\",\r\n\"href\":\"https:\/\/github.com\/NataliaTepluhina\",\r\n\"avatar\":\"https:\/\/avatars0.githubusercontent.com\/u\/18719025\"\r\n},\r\n{\r\n\"username\":\"bencodezen\",\r\n\"href\":\"https:\/\/github.com\/bencodezen\",\r\n\"avatar\":\"https:\/\/avatars1.githubusercontent.com\/u\/4836334\"\r\n},\r\n{\r\n\"username\":\"phanan\",\r\n\"href\":\"https:\/\/github.com\/phanan\",\r\n\"avatar\":\"https:\/\/avatars1.githubusercontent.com\/u\/8056274\"\r\n},\r\n{\r\n\"username\":\"sdras\",\r\n\"href\":\"https:\/\/github.com\/sdras\",\r\n\"avatar\":\"https:\/\/avatars0.githubusercontent.com\/u\/2281088\"\r\n},\r\n{\r\n\"username\":\"marina-mosti\",\r\n\"href\":\"https:\/\/github.com\/marina-mosti\",\r\n\"avatar\":\"https:\/\/avatars1.githubusercontent.com\/u\/14843771\"\r\n}\r\n]\r\n}\r\n]';
final _bodyList = jsonDecode(_body) as List;
Response _mockRightData = SuccessState<List<ModelEntity>>(
    _bodyList.map((e) => ModelEntity.fromJson(e)).toList());
Response _mockLeftData = ErrorState<Exception>(FormatException('msg 123'));

void main() {
  MockApiClient _apiClient;

  setUp(() {
    _apiClient = MockApiClient();
  });

  group('Test API Client', () {
    test('Api Call throws Exception', () async {
      when(_apiClient.getRepositories()).thenThrow(FormatException());
      expect(() async => await _apiClient.getRepositories(), throwsException);
      expect(() async => await _apiClient.getRepositories(),
          throwsA(predicate((f) => f is FormatException)));
      verify(_apiClient.getRepositories());
    });

    test('Api Call returns Error', () async {
      when(_apiClient.getRepositories()).thenAnswer((_) async => _mockLeftData);
      expect(await _apiClient.getRepositories(), isA<ErrorState>());
      verify(_apiClient.getRepositories());
      var result = (_mockLeftData as ErrorState).exception;
      expect(result, isA<Exception>());
    });

    test('Api Call returns Data', () async {
      when(_apiClient.getRepositories())
          .thenAnswer((_) async => _mockRightData);
      expect(await _apiClient.getRepositories(),
          isInstanceOf<SuccessState<List<ModelEntity>>>());
      verify(_apiClient.getRepositories());
      var result = (_mockRightData as SuccessState).value;
      expect(result, isA<List<ModelEntity>>());
      expect((result as List<ModelEntity>).length, 3);
    });
  });
}
