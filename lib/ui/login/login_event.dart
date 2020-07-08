part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {}

class LoginPasswordChanged extends LoginEvent {}

class LoginButtonPressed extends LoginEvent {}
