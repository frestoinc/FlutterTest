import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:flutterapp/ui/home/home.dart';
import 'package:flutterapp/ui/login/login_page.dart';
import 'package:flutterapp/ui/splash/splash_page.dart';

import 'di/inject.dart';
import 'ui/authentication/authentication.dart';

class CustomBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print("bloc: $bloc, event: $event");
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("bloc: $bloc, transition: $transition");
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print("bloc: $bloc, error: $error, stackTrace: $stackTrace");
    super.onError(bloc, error, stackTrace);
  }
}

void main() {
  Bloc.observer = CustomBlocObserver();
  setInjection();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      return AuthenticationBloc(manager: getIt<DataManager>())
        ..add(AuthenticationStartedEvent());
    },
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationSuccessState) {
            return HomePage();
          }

          if (state is AuthenticationFailureState) {
            return LoginPage();
          }

          return SplashPage();
        },
      ),
    );
  }
}
