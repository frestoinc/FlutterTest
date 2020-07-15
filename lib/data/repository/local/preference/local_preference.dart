import 'package:dartz/dartz.dart';
import 'package:flutterapp/data/entities/user.dart';

abstract class LocalPreference {
  Future<Either<Exception, bool>> saveCredentials(User user);

  Future<Either<Exception, String>> readCredentials();

  Future<Either<Exception, bool>> deleteCredentials();

  Future<bool> validCredentials();
}
