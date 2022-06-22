import 'package:equatable/equatable.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class InitialProfileEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class UpdateProfileEvent extends ProfileEvent {
  final int index;
  final DoctorsResponseModel doctor;
  const UpdateProfileEvent({required this.index, required this.doctor});

  @override
  List<Object> get props => [];
}
