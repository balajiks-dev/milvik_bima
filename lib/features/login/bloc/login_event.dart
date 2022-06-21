import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class InitialLoginEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class LoginButtonPressedEvent extends LoginEvent {
  final String mobileNumber;

  const LoginButtonPressedEvent({
    required this.mobileNumber,
  });

  @override
  List<Object> get props => [];
}