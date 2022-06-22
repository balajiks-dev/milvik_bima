import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class InitialRegistrationEvent extends RegistrationEvent {
  @override
  List<Object> get props => [];
}

class RegistrationButtonPressed extends RegistrationEvent {
  final String mobileNumber;
  final BuildContext context;

  const RegistrationButtonPressed({
    required this.mobileNumber,
    required this.context,
  });

  @override
  List<Object> get props => [];
}

class ClearButtonPressed extends RegistrationEvent {
  final String mobileNumber;

  const ClearButtonPressed({
    required this.mobileNumber,
  });

  @override
  List<Object> get props => [];
}

class OtpButtonPressed extends RegistrationEvent {
  final String otp;
  final BuildContext context;
  final bool isTermsSelected;


  const OtpButtonPressed({
    required this.otp,
    required this.context,
    required this.isTermsSelected
  });

  @override
  List<Object> get props => [];
}

class TermsConditionEvent extends RegistrationEvent {
  final bool isTermsChecked;

  const TermsConditionEvent({
    required this.isTermsChecked
  });

  @override
  List<Object> get props => [];
}
