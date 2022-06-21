import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class InitialDashboardEvent extends DashboardEvent {
  @override
  List<Object> get props => [];
}
