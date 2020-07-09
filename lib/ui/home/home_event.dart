part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeFetchedDataEvent extends HomeEvent {}

class HomeErrorEvent extends HomeEvent {
  final Exception error;

  const HomeErrorEvent({this.error});
}

class HomeSuccessEvent extends HomeEvent {
  final List<ModelEntity> list;

  const HomeSuccessEvent({this.list});
}
