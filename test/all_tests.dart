import 'unit/api_client.dart' as api_client;
import 'unit/authentication_bloc.dart' as authentication_bloc;
import 'unit/home_bloc.dart' as home_bloc;
import 'unit/login_bloc.dart' as login_bloc;
import 'unit/mock_manager.dart' as mock_manager;
import 'widget/home_page.dart' as home_page;
import 'widget/login_page.dart' as login_page;
import 'widget/main_page.dart' as main_page;

void main() {
  ///bloc
  authentication_bloc.main();
  home_bloc.main();
  login_bloc.main();

  ///data
  mock_manager.main();
  api_client.main();

  ///ui
  main_page.main();
  login_page.main();
  home_page.main();
}
