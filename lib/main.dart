import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/ui/splash/splash_page.dart';

import 'data/manager/data_manager.dart';
import 'di/inject.dart';
import 'ui/authentication/authentication_bloc.dart';
import 'ui/home/home_page.dart';
import 'ui/login/login_page.dart';

class CustomBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    Fimber.d('bloc: $bloc, event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    Fimber.d('change: $change');
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    Fimber.d('bloc: $bloc, transition: $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    Fimber.e('onError', ex: error, stacktrace: stackTrace);
    super.onError(cubit, error, stackTrace);
  }
}

void main(/*[ExternalApplicationCommandInvoker _invoker]*/) {
  Bloc.observer = CustomBlocObserver();
  setInjection();
  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugTree());
  /* _invoker?.addCommandHandler(
    ExternalApplicationCommand.reset,
    () async {
      await getIt<DataManager>().deleteCredentials();
      return 'ok';
    },
  );*/

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
