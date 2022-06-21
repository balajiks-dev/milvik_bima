import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(InitialDashboardState());

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is InitialDashboardEvent) {
      yield ShowProgressBar();
      yield DismissProgressBar();
      yield InitialDashboardSuccessState();
    }
  }
}
