import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:mockito/mockito.dart';

import 'mock_blocs.dart';

void main() {
  AuthenticationBloc _authBloc;

  setUp(() {
    _authBloc = MockAuthenticationBloc();
  });

  tearDown(() {
    _authBloc.close();
  });

  testWidgets('Main Page when state is AuthenticationInitialState',
      (WidgetTester tester) async {
    when(_authBloc.state).thenAnswer((_) => AuthenticationInitialState());
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>.value(value: _authBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MyApp(),
            ),
          ),
        ),
      );
      expect(find.text('Flutter App Demo'), findsOneWidget);
      expect(find.byKey(ValueKey(false)), findsOneWidget);
    });
  });

  testWidgets('Main Page when state is AuthenticationFailureState',
      (WidgetTester tester) async {
    when(_authBloc.state).thenAnswer((_) => AuthenticationFailureState());
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>.value(value: _authBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MyApp(),
            ),
          ),
        ),
      );
      expect(find.text('Login Page'), findsOneWidget);
    });
  });

  testWidgets('Main Page when state is AuthenticationSuccessState',
      (WidgetTester tester) async {
    when(_authBloc.state)
        .thenAnswer((_) => AuthenticationSuccessState(emailAddress: null));
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>.value(value: _authBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MyApp(),
            ),
          ),
        ),
      );
      expect(find.text('Home Page'), findsOneWidget);
    });
  });
}
