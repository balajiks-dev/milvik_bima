import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';
import 'package:milvik_bima/network/api_services.dart';
import 'package:milvik_bima/network/meta.dart';
import 'package:milvik_bima/utils/keys.dart';
import 'package:milvik_bima/utils/sputils.dart';
import 'package:milvik_bima/utils/url_utils.dart';
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
      String doctorsListString = SPUtil.getString(KeyStrings.kDoctorsList);
      if(doctorsListString.isNotEmpty){
        List<DoctorsResponseModel> doctorsList = <DoctorsResponseModel>[];
        jsonDecode(doctorsListString).forEach(
                (f) => doctorsList.add(DoctorsResponseModel.fromJson(f)));
        doctorsList.sort((a,b) => b.rating.compareTo(a.rating));
        yield DismissProgressBar();
        yield InitialDashboardSuccessState(doctorsList: doctorsList);
      } else {
        Meta meta = await APIServices().processGetURL(
            URLUtils().getDoctorsList(), '');
        if (meta.statusCode == 200) {
          List<DoctorsResponseModel> doctorsList = <DoctorsResponseModel>[];
          jsonDecode(meta.statusMsg).forEach(
                  (f) => doctorsList.add(DoctorsResponseModel.fromJson(f)));
          doctorsList.sort((a, b) => b.rating.compareTo(a.rating));
          SPUtil.putString(KeyStrings.kDoctorsList, meta.statusMsg);
          yield DismissProgressBar();
          yield InitialDashboardSuccessState(doctorsList: doctorsList);
        } else {
          yield DismissProgressBar();
          yield InitialDashboardFailureState(error: meta.statusMsg);
        }
      }
    }
  }
}
