part of 'splash_bloc.dart';

///
/// Define for Splash Event
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///
abstract class SplashEvent extends Equatable {
  const SplashEvent();
}

class AppStarted extends SplashEvent {
  @override
  List<Object> get props => [];
}
