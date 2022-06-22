import 'package:equatable/equatable.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class InitialProfileState extends ProfileState {
  @override
  List<Object> get props => [];
}

class ShowProgressBar extends ProfileState {
  @override
  List<Object> get props => [];
}

class DismissProgressBar extends ProfileState {
  @override
  List<Object> get props => [];
}

class NetworkFailureState extends ProfileState {
  final String error;

  const NetworkFailureState({required this.error});
  @override
  List<Object> get props => [error];
}

class UpdateProfileSuccessState extends ProfileState {
  @override
  List<Object> get props => [];
}

class InitialProfileFailureState extends ProfileState {
  final String error;

  const InitialProfileFailureState({required this.error});
  @override
  List<Object> get props => [error];
}
