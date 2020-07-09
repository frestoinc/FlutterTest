part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final List<ModelEntity> entities;

  const HomeSuccessState({this.entities});
}

class HomeFailureState extends HomeState {
  final Exception error;

  const HomeFailureState({@required this.error});
}
