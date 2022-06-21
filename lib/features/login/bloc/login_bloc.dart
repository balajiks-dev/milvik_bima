import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:milvik_bima/network/api_services.dart';
import 'package:milvik_bima/network/meta.dart';
import 'package:milvik_bima/utils/constants.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitialLoginState());

  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
  ) async* {
    if (event is InitialLoginEvent) {
      yield ShowProgressBar();
      yield InitialLoginState();
      yield DismissProgressBar();
    } else if (event is LoginButtonPressedEvent){
      yield ShowProgressBar();
      if(event.mobileNumber.isNotEmpty){
       // Meta meta = await APIServices.loginEmailAndPasswordUser(event.emailId, event.password);
        Meta meta = Meta(statusCode: 200, statusMsg: 'Invalid');
        if(meta.statusCode == 200){
          yield DismissProgressBar();
          yield LoginSuccessState();
        } else {
          yield LoginFailureState(error: meta.statusMsg);
          yield DismissProgressBar();
        }
      } else {
        String error = AppStrings.enterPhoneNumber;
        yield LoginFailureState(error: error);
        yield DismissProgressBar();
      }
    }
  }
}
