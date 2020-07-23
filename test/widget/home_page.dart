import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:flutterapp/ui/home/home_bloc.dart';
import 'package:flutterapp/ui/home/home_page.dart';
import 'package:mockito/mockito.dart';

import 'mock_blocs.dart';

void main() {
  AuthenticationBloc _authBloc;
  HomeBloc _homeBloc;

  setUp(() {
    _authBloc = MockAuthenticationBloc();
    _homeBloc = MockHomeBloc();
  });

  tearDown(() {
    _authBloc.close();
    _homeBloc.close();
  });

  testWidgets('Home Page when state is HomeInitialState',
      (WidgetTester tester) async {
    when(_homeBloc.state).thenReturn(HomeLoadingState());
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>.value(value: _authBloc),
            BlocProvider<HomeBloc>.value(value: _homeBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: HomePage(),
            ),
          ),
        ),
      );
      expect(find.text('Home Page'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
