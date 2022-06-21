import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class InitialLoginState extends LoginState {
  @override
  List<Object> get props => [];
}

class ShowProgressBar extends LoginState {
  @override
  List<Object> get props => [];
}

class DismissProgressBar extends LoginState {
  @override
  List<Object> get props => [];
}

class NetworkFailureState extends LoginState {
  final String error;

  const NetworkFailureState({required this.error});
  @override
  List<Object> get props => [error];
}

class LoginFailureState extends LoginState {
  final String error;

  const LoginFailureState({required this.error});
  @override
  List<Object> get props => [error];
}

class LoginSuccessState extends LoginState {
  @override
  List<Object> get props => [];
}
