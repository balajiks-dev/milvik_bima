import 'package:equatable/equatable.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';

///
/// Define for Dashboard State
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///

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

class DoctorsViewChangedState extends DashboardState {
  final bool isListView;
  const DoctorsViewChangedState({required this.isListView});
  @override
  List<Object> get props => [];
}