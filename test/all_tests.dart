import 'unit/api_client.dart' as api_client;
import 'unit/authentication_bloc.dart' as authentication_bloc;
import 'unit/home_bloc.dart' as home_bloc;
import 'unit/login_bloc.dart' as login_bloc;
import 'unit/mock_manager.dart' as mock_manager;

void main() {
  ///bloc
  authentication_bloc.main();
  home_bloc.main();
  login_bloc.main();

  ///data
  mock_manager.main();
  api_client.main();
}
