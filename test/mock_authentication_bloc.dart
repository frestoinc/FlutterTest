import 'package:bloc_test/bloc_test.dart';
import 'package:flutterapp/ui/authentication/authentication.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}
