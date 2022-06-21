import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:milvik_bima/utils/keys.dart';
import 'package:milvik_bima/utils/sputils.dart';

import '../../../network/api_services.dart';
import '../../app/bloc/authentication_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

bool istesting = true;

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({required this.authenticationBloc}) : super(SplashInitial());
  AuthenticationBloc authenticationBloc;

  @override
  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {
    if (event is AppStarted) {
      //Important - initializing dio
      APIServices().configAPI();
      await initializeFirebaseCrashlytics();
      await Future.delayed(const Duration(seconds: 3));
      await SPUtil.getInstance();
      if (SPUtil.getString(KeyStrings.kLoginToken).isNotEmpty) {
        authenticationBloc.add(const AuthenticationStatusChanged(
            AuthenticationStatus.authenticated));
      } else {
        authenticationBloc.add(const AuthenticationStatusChanged(
            AuthenticationStatus.unauthenticated));
      }

    }
  }
}

Future<void> initializeFirebaseCrashlytics() async {
  if (istesting) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
}

