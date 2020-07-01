import 'package:flutterapp/data/api/remote_api.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:flutterapp/data/manager/data_manager_impl.dart';
import 'package:flutterapp/data/remote/remote_repository.dart';
import 'package:flutterapp/data/remote/remote_repository_impl.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setInjection() {
  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerSingleton<RemoteRepository>(RemoteRepositoryImpl(getIt.get()));
  getIt.registerSingleton<DataManager>(DataManagerImpl(getIt.get()));
}
