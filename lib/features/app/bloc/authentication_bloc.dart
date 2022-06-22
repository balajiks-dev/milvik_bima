import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

///
/// Define for App Bloc
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///
///
enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationState.unauthenticated());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event);
    }
    }
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
    AuthenticationStatusChanged event,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const AuthenticationState.unauthenticated();
      case AuthenticationStatus.authenticated:
        return const AuthenticationState.authenticated();

      default:
        return const AuthenticationState.unknown();
    }
  }

