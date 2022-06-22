import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milvik_bima/shared_widgets/snack_bar.dart';
import 'package:milvik_bima/utils/colors.dart';

import '../../utils/assets.dart';
import '../app/bloc/authentication_bloc.dart';

import 'bloc/splash_bloc.dart';

///
/// Define for Splash Page
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return SplashBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          )..add(AppStarted());
        },
        child: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is FailureState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBarWidget(state.error));
            }
          },
          child: BlocBuilder<SplashBloc, SplashState>(
            builder: (context, state) {
              return showLogo();
            },
          ),
        ));
  }

  Widget showLogo() {
    return Scaffold(
      backgroundColor: ColorData.kcWhite,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              UIAssets.splashImage,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

