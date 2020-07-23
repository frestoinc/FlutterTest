import 'package:bloc_test/bloc_test.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:flutterapp/ui/home/home_bloc.dart';
import 'package:flutterapp/ui/login/login_bloc.dart';

class MockAuthenticationBloc extends MockBloc<AuthenticationState>
    implements AuthenticationBloc {}

class MockLoginBloc extends MockBloc<LoginState> implements LoginBloc {}

class MockHomeBloc extends MockBloc<HomeState> implements HomeBloc {}
