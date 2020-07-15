import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterapp/data/entities/entities.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final DataManager manager;

  AuthenticationBloc({@required this.manager})
      : super(AuthenticationInitialState());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    yield AuthenticationInProgressState();

    if (event is AuthenticationStartedEvent) {
      final bool valid = await manager.validCredentials();

      await Future.delayed(Duration(seconds: 6), () {});

      if (valid) {
        yield AuthenticationSuccessState();
      } else {
        yield AuthenticationFailureState();
      }
    }

    if (event is AuthenticationLoggedInEvent) {
      yield AuthenticationInProgressState();
      await manager.saveCredentials(event.user);
      yield AuthenticationSuccessState();
    }

    if (event is AuthenticationLoggedOutEvent) {
      yield AuthenticationInProgressState();
      await manager.deleteCredentials();
      yield AuthenticationFailureState();
    }
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

class AuthenticationSuccessState extends AuthenticationState {}

class AuthenticationFailureState extends AuthenticationState {}

class AuthenticationInProgressState extends AuthenticationState {}
