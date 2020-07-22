import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/extension/response.dart';
import 'package:flutterapp/services/remote_api.dart';
import 'package:mockito/mockito.dart';

import 'data.dart';

class MockApiClient extends Mock implements ApiClient {}

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
      when(_apiClient.getRepositories()).thenAnswer((_) async => mockLeftData);
      expect(await _apiClient.getRepositories(), isA<ErrorState>());
      verify(_apiClient.getRepositories());
      var result = (mockLeftData as ErrorState).exception;
      expect(result, isA<Exception>());
    });

    test('Api Call returns Data', () async {
      when(_apiClient.getRepositories()).thenAnswer((_) async => mockRightData);
      expect(await _apiClient.getRepositories(),
          isInstanceOf<SuccessState<List<ModelEntity>>>());
      verify(_apiClient.getRepositories());
      var result = (mockRightData as SuccessState).value;
      expect(result, isA<List<ModelEntity>>());
      expect((result as List<ModelEntity>).length, 3);
    });
  });
}
