import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milvik_bima/features/dashboard/dashboard_page.dart';
import 'package:milvik_bima/features/registration/registration.dart';
import 'package:milvik_bima/features/splash/splash.dart';
import 'package:milvik_bima/utils/colors.dart';
import 'package:milvik_bima/utils/text_styles.dart';
import 'bloc/authentication_bloc.dart';

///
/// Define for App Page
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationBloc(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              //Set the Theme Color here
              primaryColor: ColorData.kcPrimaryColor,
              textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: ktsFontStyle14RegularBlack,
              ),
            ),
            home: BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (BuildContext context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const DashboardPage()),
                        ModalRoute.withName('/'));
                    break;
                  case AuthenticationStatus.unauthenticated:
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const RegistrationPage()),
                        ModalRoute.withName('/'));
                    break;
                  default:
                    break;
                }
              },
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return const SplashPage();
                },
              ),
            ),
          ),

    );
  }
}