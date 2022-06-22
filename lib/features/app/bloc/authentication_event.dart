part of 'authentication_bloc.dart';

///
/// Define for App Event
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///
///
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}
