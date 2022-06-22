import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milvik_bima/features/registration/otp_screen.dart';
import 'package:milvik_bima/shared_widgets/snack_bar.dart';
import 'package:milvik_bima/utils/constants.dart';
import 'package:milvik_bima/utils/keys.dart';
import 'package:milvik_bima/utils/sputils.dart';

import 'registration_event.dart';
import 'registration_state.dart';

String verificationId = "";

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(InitialRegistrationState());

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    FirebaseAuth _auth = FirebaseAuth.instance;

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
      if (event.mobileNumber.isNotEmpty && event.mobileNumber.length > 10) {
        // TextEditingController _codeController = TextEditingController();
        _auth.verifyPhoneNumber(
          phoneNumber: event.mobileNumber,
          timeout: const Duration(seconds: 120),
          verificationCompleted: (AuthCredential credential) async {
            ScaffoldMessenger.of(event.context).showSnackBar(snackBarWidget(
              AppStrings.otpSentSuccessfully,
            ));
          },
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(event.context).showSnackBar(snackBarWidget(
              e.message!,
            ));
            print(e.message);
          },
          codeSent: (String? verificationCodeId, [int? forceResendingToken]) {
            verificationId = verificationCodeId ?? "";
            ScaffoldMessenger.of(event.context).showSnackBar(snackBarWidget(
              AppStrings.otpSentSuccessfully,
            ));
            Navigator.push(event.context,
                MaterialPageRoute(builder: (context) => OtpPage()));
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        yield DismissProgressBar();
        yield RegistrationFailureState(
            error: event.mobileNumber.isEmpty ? AppStrings.enterPhoneNumber : AppStrings.enterValidPhoneNumber);
      }
    }
    else if (event is OtpButtonPressed) {
      yield ShowProgressBar();
      if (event.otp.isNotEmpty && event.otp.length == 6 && event.isTermsSelected){
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: event.otp,
      );
      UserCredential result;
      try {
        result = await _auth.signInWithCredential(credential);
        debugPrint(result.toString());
        SPUtil.putString(KeyStrings.kUserId, result.user!.uid);
        yield DismissProgressBar();
        yield OtpSuccessState();
      } catch (e) {
        debugPrint(e.toString());
        yield DismissProgressBar();
        yield const OtpFailureState(error: AppStrings.invalidOTP);
      }
      } else {
        yield DismissProgressBar();
        yield OtpFailureState(error: event.otp.isEmpty ? AppStrings.enterOTP : event.otp.length != 6 ? AppStrings.enterValidOTP : AppStrings.checkTermsAndCondition);
      }
    } else if(event is TermsConditionEvent){
      yield ShowProgressBar();
      yield TermsConditionState(isTermsChecked: event.isTermsChecked);
      yield DismissProgressBar();
    }
  }
}
