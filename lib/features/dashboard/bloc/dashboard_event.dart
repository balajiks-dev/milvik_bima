import 'package:equatable/equatable.dart';

///
/// Define for Dashboard Event
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class InitialDashboardEvent extends DashboardEvent {
  @override
  List<Object> get props => [];
}

class DoctorsViewChangedEvent extends DashboardEvent {
  final bool isListView;
  const DoctorsViewChangedEvent({required this.isListView});
  @override
  List<Object> get props => [];
}
