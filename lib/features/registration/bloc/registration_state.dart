import 'package:equatable/equatable.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();
}

class InitialRegistrationState extends RegistrationState {
  @override
  List<Object> get props => [];
}

class ShowProgressBar extends RegistrationState {
  @override
  List<Object> get props => [];
}

class DismissProgressBar extends RegistrationState {
  @override
  List<Object> get props => [];
}

class NetworkFailureState extends RegistrationState {
  final String error;

  const NetworkFailureState({required this.error});
  @override
  List<Object> get props => [error];
}

class RegistrationFailureState extends RegistrationState {
  final String error;

  const RegistrationFailureState({required this.error});
  @override
  List<Object> get props => [error];
}

class RegistrationSuccessState extends RegistrationState {
  @override
  List<Object> get props => [];
}

class OtpSuccessState extends RegistrationState {
  @override
  List<Object> get props => [];
}

class OtpFailureState extends RegistrationState {
  final String error;

  const OtpFailureState({required this.error});
  @override
  List<Object> get props => [error];
}

class ClearButtonPressedState extends RegistrationState {
  final String mobileNumber;

  const ClearButtonPressedState({
    required this.mobileNumber,
  });
  @override
  List<Object> get props => [];
}
