import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:flutterapp/ui/login/login_bloc.dart';
import 'package:flutterapp/ui/login/login_page.dart';
import 'package:mockito/mockito.dart';

import 'mock_blocs.dart';

void main() {
  AuthenticationBloc _authBloc;
  LoginBloc _loginBloc;

  setUp(() {
    _authBloc = MockAuthenticationBloc();
    _loginBloc = MockLoginBloc();
  });

  tearDown(() {
    _authBloc.close();
    _loginBloc.close();
  });

  testWidgets('Login Page when state is LoginInitialState',
      (WidgetTester tester) async {
    when(_loginBloc.state).thenAnswer((_) => LoginInitialState());
    await tester.runAsync(() async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: _authBloc,
          child: MaterialApp(
            home: Scaffold(
              body: LoginPage(),
            ),
          ),
        ),
      );
      expect(find.text('LOGIN FORM'), findsOneWidget);
      expect(find.text('LOGIN'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });
  });
}
