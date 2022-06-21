import 'package:equatable/equatable.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
}

class InitialDashboardState extends DashboardState {
  @override
  List<Object> get props => [];
}

class ShowProgressBar extends DashboardState {
  @override
  List<Object> get props => [];
}

class DismissProgressBar extends DashboardState {
  @override
  List<Object> get props => [];
}

class NetworkFailureState extends DashboardState {
  final String error;

  const NetworkFailureState({required this.error});
  @override
  List<Object> get props => [error];
}

class InitialDashboardSuccessState extends DashboardState {
  final List<DoctorsResponseModel> doctorsList;
  const InitialDashboardSuccessState({required this.doctorsList});
  @override
  List<Object> get props => [];
}

class InitialDashboardFailureState extends DashboardState {
  final String error;

  const InitialDashboardFailureState({required this.error});
  @override
  List<Object> get props => [error];
}
