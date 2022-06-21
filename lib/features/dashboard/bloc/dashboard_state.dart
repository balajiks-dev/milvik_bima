import 'package:equatable/equatable.dart';

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
  @override
  List<Object> get props => [];
}

