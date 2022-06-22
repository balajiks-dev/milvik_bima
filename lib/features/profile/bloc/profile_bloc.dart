import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';
import 'package:milvik_bima/network/api_services.dart';
import 'package:milvik_bima/network/meta.dart';
import 'package:milvik_bima/utils/constants.dart';
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
      if(event.firstName.isNotEmpty && event.lastName.isNotEmpty){
      String doctorsListString = SPUtil.getString(KeyStrings.kDoctorsList);
      List<DoctorsResponseModel> doctorsList = <DoctorsResponseModel>[];
      jsonDecode(doctorsListString).forEach(
              (f) => doctorsList.add(DoctorsResponseModel.fromJson(f)));
      doctorsList.sort((a,b) => b.rating.compareTo(a.rating));
      doctorsList[event.index] = DoctorsResponseModel(
          id: doctorsList[event.index].id,
          firstName: event.firstName,
          lastName: event.lastName,
          profilePic: doctorsList[event.index].profilePic,
          favorite: doctorsList[event.index].favorite,
          primaryContactNo: event.contactNumber,
          rating: doctorsList[event.index].rating,
          emailAddress: doctorsList[event.index].emailAddress,
          qualification: doctorsList[event.index].qualification,
          description: doctorsList[event.index].description,
          specialization: doctorsList[event.index].specialization,
          languagesKnown: doctorsList[event.index].languagesKnown,
          gender: event.gender,
          height: event.height,
          weight: event.weight);
      SPUtil.clearString(KeyStrings.kDoctorsList);
      SPUtil.putString(KeyStrings.kDoctorsList, jsonEncode(doctorsList));
      yield DismissProgressBar();
      yield UpdateProfileSuccessState();
      } else {
        yield DismissProgressBar();
        yield InitialProfileFailureState(error: event.firstName.isEmpty ? AppStrings.enterFirstName : AppStrings.enterLastName);
      }
    } else if (event is EditProfileEvent){
      yield ShowProgressBar();
      yield DismissProgressBar();
      yield EditProfileState(selected: event.selected);
    } else if (event is ProfilePictureNotAddEvent){
      yield ShowProgressBar();
      yield DismissProgressBar();
      yield const InitialProfileFailureState(error: AppStrings.imageNotSelected);
    } else if (event is ProfilePictureAddEvent){
      yield ShowProgressBar();
      String doctorsListString = SPUtil.getString(KeyStrings.kDoctorsList);
      List<DoctorsResponseModel> doctorsList = <DoctorsResponseModel>[];
      jsonDecode(doctorsListString).forEach(
              (f) => doctorsList.add(DoctorsResponseModel.fromJson(f)));
      doctorsList.sort((a,b) => b.rating.compareTo(a.rating));
      doctorsList[event.index] = DoctorsResponseModel(
          id: doctorsList[event.index].id,
          firstName: doctorsList[event.index].firstName,
          lastName: doctorsList[event.index].lastName,
          profilePic: event.image.path,
          favorite: doctorsList[event.index].favorite,
          primaryContactNo: doctorsList[event.index].primaryContactNo,
          rating: doctorsList[event.index].rating,
          emailAddress: doctorsList[event.index].emailAddress,
          qualification: doctorsList[event.index].qualification,
          description: doctorsList[event.index].description,
          specialization: doctorsList[event.index].specialization,
          languagesKnown: doctorsList[event.index].languagesKnown,
          gender: doctorsList[event.index].gender,
          height: doctorsList[event.index].height,
          weight: doctorsList[event.index].weight,
          imageEdited: true
      );
      SPUtil.clearString(KeyStrings.kDoctorsList);
      SPUtil.putString(KeyStrings.kDoctorsList, jsonEncode(doctorsList));
      yield DismissProgressBar();
      yield UpdateProfileSuccessState();
    }
  }
}
