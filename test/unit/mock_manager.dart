import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/data/entities/entities.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:flutterapp/extension/response.dart';
import 'package:mockito/mockito.dart';

class MockDataManager extends Mock implements DataManager {}

void main() {
  MockDataManager _manager;

  setUp(() {
    _manager = MockDataManager();
  });

  tearDown(() {
    _manager = null;
  });

  group('Test Get Repositories', () {
    test('Empty List', () async {
      when(_manager.getRepositories()).thenAnswer(
          (_) async => SuccessState<List<ModelEntity>>(<ModelEntity>[]));
      expect(await _manager.getRepositories(),
          isInstanceOf<SuccessState<List<ModelEntity>>>());
      var _response = await _manager.getRepositories();
      List<ModelEntity> list = (_response as SuccessState).value;
      expect(list.length, 0);
    });

    test('Error', () async {
      when(_manager.getRepositories())
          .thenThrow(TimeoutException(null, Duration(seconds: 10)));
      expect(() async => await _manager.getRepositories(), throwsException);
      expect(() async => await _manager.getRepositories(),
          throwsA(predicate((f) => f is Exception)));
    });
  });

  group('Test Delete Credentials', () {
    test('SuccessState', () async {
      when(_manager.deleteCredentials())
          .thenAnswer((_) async => Response<bool>.success(true));
      expect(await _manager.deleteCredentials(),
          isInstanceOf<SuccessState<bool>>());
      var _response = await _manager.deleteCredentials();
      expect((_response as SuccessState).value, isTrue);
    });

    test('ErrorState', () async {
      when(_manager.deleteCredentials()).thenThrow(Exception());
      expect(() async => await _manager.deleteCredentials(), throwsException);
      expect(() async => await _manager.deleteCredentials(),
          throwsA(predicate((f) => f is Exception)));
    });
  });

  group('Test Read Credentials', () {
    test('SuccessState', () async {
      when(_manager.readCredentials())
          .thenAnswer((_) async => Response<String>.success('abc'));
      expect(await _manager.readCredentials(),
          isInstanceOf<SuccessState<String>>());
      var _credentials = await _manager.readCredentials();
      expect((_credentials as SuccessState).value, 'abc');
    });

    test('ErrorState', () async {
      when(_manager.readCredentials()).thenThrow(Exception());
      expect(() async => await _manager.readCredentials(), throwsException);
      expect(() async => await _manager.readCredentials(),
          throwsA(predicate((f) => f is Exception)));
    });
  });

  group('Test Save Credentials', () {
    final user = User(emailAddress: 'a', password: 'b');
    test('SuccessState', () async {
      when(_manager.saveCredentials(user))
          .thenAnswer((_) async => Response<bool>.success(true));
      expect(await _manager.saveCredentials(user),
          isInstanceOf<SuccessState<bool>>());
      var _response = await _manager.saveCredentials(user);
      expect((_response as SuccessState).value, isTrue);
    });

    test('ErrorState', () async {
      when(_manager.saveCredentials(user)).thenThrow(Exception());
      expect(() async => await _manager.saveCredentials(user), throwsException);
      expect(() async => await _manager.saveCredentials(user),
          throwsA(predicate((f) => f is Exception)));
    });
  });

  group('Test Valid Credentials', () {
    test('isNotEmpty', () async {
      when(_manager.validCredentials()).thenAnswer((_) async => true);
      expect(await _manager.validCredentials(), isInstanceOf<bool>());
      var _credentials = await _manager.validCredentials();
      expect(_credentials, isTrue);
    });

    test('isEmpty', () async {
      when(_manager.validCredentials()).thenAnswer((_) async => false);
      expect(await _manager.validCredentials(), isInstanceOf<bool>());
      var _credentials = await _manager.validCredentials();
      expect(_credentials, isFalse);
    });

    test('onException', () async {
      when(_manager.validCredentials()).thenThrow(Exception());
      expect(() async => await _manager.validCredentials(), throwsException);
      expect(() async => await _manager.validCredentials(),
          throwsA(predicate((f) => f is Exception)));
    });
  });
}
