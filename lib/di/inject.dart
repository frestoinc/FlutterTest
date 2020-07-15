import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:flutterapp/data/manager/data_manager_impl.dart';
import 'package:flutterapp/data/repository/local/preference/local_preference.dart';
import 'package:flutterapp/data/repository/local/preference/local_preference_impl.dart';
import 'package:flutterapp/data/repository/remote/remote_repository.dart';
import 'package:flutterapp/data/repository/remote/remote_repository_impl.dart';
import 'package:flutterapp/services/remote_api.dart';
import 'package:get_it/get_it.dart';

import 'file:///C:/Users/root/Documents/AndroidStudioProjects/Projects/flutter_app/lib/extension/dialogs/dialog.dart';

GetIt getIt = GetIt.instance;

void setInjection() {
  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());
  getIt.registerLazySingleton(() => DialogService());
  getIt.registerSingleton<RemoteRepository>(RemoteRepositoryImpl(getIt.get()));
  getIt.registerSingleton<LocalPreference>(LocalPreferenceImpl(getIt.get()));
  getIt.registerSingleton<DataManager>(
      DataManagerImpl(getIt.get(), getIt.get()));
}
