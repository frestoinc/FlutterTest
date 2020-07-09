part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChangedEvent extends LoginEvent {}

class LoginPasswordChangedEvent extends LoginEvent {}

class LoginButtonPressedEvent extends LoginEvent {}
