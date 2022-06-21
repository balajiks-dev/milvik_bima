import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {

  SimpleBlocObserver();
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
  }
}
