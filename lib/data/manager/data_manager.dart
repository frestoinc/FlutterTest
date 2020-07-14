import 'package:flutterapp/data/repository/local/preference/local_preference.dart';
import 'package:flutterapp/data/repository/remote/remote_repository.dart';

abstract class DataManager implements RemoteRepository, LocalPreference {}
