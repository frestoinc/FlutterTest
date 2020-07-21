import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterapp/data/entities/entities.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final DataManager manager;

  AuthenticationBloc({@required this.manager})
      : super(AuthenticationInitialState());

  @override
  Stream<Transition<AuthenticationEvent, AuthenticationState>> transformEvents(
    Stream<AuthenticationEvent> events,
    Stream<Transition<AuthenticationEvent, AuthenticationState>> Function(
      AuthenticationEvent event,
    )
        transitionFn,
  ) {
    return events
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap(transitionFn);
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    yield AuthenticationInProgressState();

    if (event is AuthenticationStartedEvent) {
      final valid = await manager.validCredentials();

      await Future.delayed(Duration(seconds: 6), () {});

      if (valid) {
        final credentials = await manager
            .readCredentials()
            .then((value) => value.fold((l) => "Unknown", (r) => r));
        yield AuthenticationSuccessState(emailAddress: credentials);
      } else {
        yield AuthenticationFailureState();
      }
    }

    if (event is AuthenticationLoggedInEvent) {
      yield AuthenticationInProgressState();
      await manager.saveCredentials(event.user);
      yield AuthenticationSuccessState(emailAddress: event.user.emailAddress);
    }

    if (event is AuthenticationLoggedOutEvent) {
      yield AuthenticationInProgressState();
      await manager.deleteCredentials();
      yield AuthenticationFailureState();
    }
  }

  void onLoggedOutPressed() {
    this.add(AuthenticationLoggedOutEvent());
  }
}

///EVENTS///
@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStartedEvent extends AuthenticationEvent {}

class AuthenticationLoggedInEvent extends AuthenticationEvent {
  final User user;

  const AuthenticationLoggedInEvent({@required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'AuthenticationLoggedIn { user: $user }';
}

class AuthenticationLoggedOutEvent extends AuthenticationEvent {}

///STATES///
@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {}

class AuthenticationSuccessState extends AuthenticationState {
  final String emailAddress;

  const AuthenticationSuccessState({@required this.emailAddress});
}

class AuthenticationFailureState extends AuthenticationState {}

class AuthenticationInProgressState extends AuthenticationState {}
