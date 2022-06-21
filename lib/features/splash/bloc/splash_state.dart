part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashInitial extends SplashState {
  @override
  List<Object> get props => [];
}

class FailureState extends SplashState {
  final String error;

  const FailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class AppUpdateAvailableState extends SplashState {
  @override
  List<Object> get props => [];
}
