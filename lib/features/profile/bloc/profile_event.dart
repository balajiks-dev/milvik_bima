import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class InitialProfileEvent extends ProfileEvent {
  final int index;
  const InitialProfileEvent({required this.index});
  @override
  List<Object> get props => [];
}

class UpdateProfileEvent extends ProfileEvent {
  final int index;
  final String firstName;
  final String lastName;
  final String gender;
  final String contactNumber;
  final String height;
  final String weight;
  const UpdateProfileEvent({required this.index, required this.firstName, required this.lastName, required this.contactNumber, required this.gender, required this.height, required this.weight});

  @override
  List<Object> get props => [];
}

class EditProfileEvent extends ProfileEvent {
  final bool selected;
  const EditProfileEvent({required this.selected});

  @override
  List<Object> get props => [];
}

class ProfilePictureAddEvent extends ProfileEvent {
  final File image;
  final int index;
  const ProfilePictureAddEvent({required this.image, required this.index});

  @override
  List<Object> get props => [];
}

class ProfilePictureNotAddEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}
