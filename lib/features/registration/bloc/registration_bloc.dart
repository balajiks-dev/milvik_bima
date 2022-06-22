import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milvik_bima/shared_widgets/snack_bar.dart';
import 'package:milvik_bima/utils/constants.dart';

import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(InitialRegistrationState());

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is InitialRegistrationEvent) {
      yield ShowProgressBar();
      yield InitialRegistrationState();
      yield DismissProgressBar();
    } else if (event is ClearButtonPressed) {
      yield ShowProgressBar();
      yield const ClearButtonPressedState(mobileNumber: '');
      yield DismissProgressBar();
    } else if (event is RegistrationButtonPressed) {
      yield ShowProgressBar();
      if(event.mobileNumber.isNotEmpty){
      FirebaseAuth _auth = FirebaseAuth.instance;
      // TextEditingController _codeController = TextEditingController();
      _auth.verifyPhoneNumber(
        phoneNumber: event.mobileNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (AuthCredential credential) async {
          ScaffoldMessenger.of(event.context).showSnackBar(snackBarWidget(
            "OTP Sent to your phone number successfully!",
          ));
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(event.context).showSnackBar(snackBarWidget(
            e.message!,
          ));
        },
        codeSent: (String? verificationId, [int? forceResendingToken]) {

          // return Container();
          // showDialog(
          //     context: event.context,
          //     barrierDismissible: false,
          //     builder: (BuildContext context) {
          //       print(verificationId);
          //       return Container();
          //     });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      yield DismissProgressBar();

      } else {
        yield DismissProgressBar();
        yield const RegistrationFailureState(error: AppStrings.enterPhoneNumber);
      }
    }
    if (event is OtpButtonPressed) {
      yield ShowProgressBar();
      if (event.otp == "123456") {
        yield DismissProgressBar();
        yield OtpSuccessState();
      } else {
        yield DismissProgressBar();
        yield const OtpFailureState(error: AppStrings.invalidOTP);
      }
    }
  }
}
