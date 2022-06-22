import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';
import 'package:milvik_bima/network/api_services.dart';
import 'package:milvik_bima/network/meta.dart';
import 'package:milvik_bima/utils/keys.dart';
import 'package:milvik_bima/utils/sputils.dart';
import 'package:milvik_bima/utils/url_utils.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(InitialProfileState());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if(event is InitialProfileEvent){
      yield ShowProgressBar();
      String doctorsListString = SPUtil.getString(KeyStrings.kDoctorsList);
      List<DoctorsResponseModel> doctorsList = <DoctorsResponseModel>[];
      jsonDecode(doctorsListString).forEach(
              (f) => doctorsList.add(DoctorsResponseModel.fromJson(f)));
      doctorsList.sort((a,b) => b.rating.compareTo(a.rating));
      yield DismissProgressBar();
      yield InitialProfileSuccessState(doctorModel: doctorsList[event.index]);
    }
    else if (event is UpdateProfileEvent) {
      yield ShowProgressBar();
      yield DismissProgressBar();
      yield UpdateProfileSuccessState();
    }
  }
}
