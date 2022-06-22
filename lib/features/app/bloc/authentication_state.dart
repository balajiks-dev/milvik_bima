part of 'authentication_bloc.dart';

///
/// Define for App State
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///
///
class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.authenticated()
      : this._(status: AuthenticationStatus.authenticated);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}
