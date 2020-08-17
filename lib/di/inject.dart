import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:flutterapp/data/repository/local/directory.dart';
import 'package:flutterapp/data/repository/local/local_preference.dart';
import 'package:flutterapp/data/repository/remote/remote_repository.dart';
import 'package:flutterapp/extension/location_helper.dart';
import 'package:flutterapp/services/remote_api.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setInjection() {
  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerSingleton<PictureDirectory>(PictureDirectoryImpl());
  getIt.registerSingleton<LocationHelper>(LocationHelperImpl());
  getIt.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());
  getIt.registerSingleton<RemoteRepository>(RemoteRepositoryImpl(getIt.get()));
  getIt.registerSingleton<LocalPreference>(LocalPreferenceImpl(getIt.get()));
  getIt.registerSingleton<DataManager>(
      DataManagerImpl(getIt.get(), getIt.get()));
}
