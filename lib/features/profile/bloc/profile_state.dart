import 'package:equatable/equatable.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class InitialProfileState extends ProfileState {
  @override
  List<Object> get props => [];
}

class InitialProfileSuccessState extends ProfileState {
  final DoctorsResponseModel doctorModel;
  const InitialProfileSuccessState({required this.doctorModel});
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

class EditProfileState extends ProfileState {
  final bool selected;
  const EditProfileState({required this.selected});

  @override
  List<Object> get props => [];
}

class DateofBirthChangeState extends ProfileState {
  final int birthDay;
  final int birthMonth;
  final int birthYear;
  const DateofBirthChangeState({required this.birthDay, required this.birthMonth, required this.birthYear});
  @override
  List<Object> get props => [];
}