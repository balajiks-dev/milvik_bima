import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milvik_bima/features/dashboard/dashboard_page.dart';
import 'package:milvik_bima/features/login/bloc/login_bloc.dart';
import 'package:milvik_bima/features/login/bloc/login_event.dart';
import 'package:milvik_bima/features/login/bloc/login_state.dart';
import 'package:milvik_bima/shared_widgets/loading_indicator.dart';
import 'package:milvik_bima/shared_widgets/snack_bar.dart';
import 'package:milvik_bima/utils/constants.dart';
import 'package:milvik_bima/utils/text_styles.dart';
import 'package:milvik_bima/utils/ui_helpers.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneNumberTextController = TextEditingController();

    Future<bool> _willPopCallback() async {
      // await showDialog or Show add banners or whatever
      // then
      return false; // return true if the route to be popped
    }

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: BlocProvider(
          create: (context) {
            return LoginBloc();
          },
          child: BlocListener<LoginBloc, LoginState>(
            listener: (BuildContext context, state) {
              if (state is DismissProgressBar) {
                DialogBuilder(context).hideOpenDialog();
              } else if (state is ShowProgressBar) {
                DialogBuilder(context).showLoadingIndicator();
              } else if (state is LoginFailureState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBarWidget(state.error));
              } else if (state is LoginSuccessState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBarWidget(AppStrings.loginSuccess));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const DashboardPage()),
                    ModalRoute.withName('/'));
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppStrings.login,
                          style: ktsFontStyle16Regular,
                        ),
                        SizedBox(height: screenHeight(context) * 0.03),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<LoginBloc>(context).add(
                                LoginButtonPressedEvent(mobileNumber: 'dda'));
                          },
                          child: Container(
                            child: Text('Login'),
                          ),
                        ),
                        SizedBox(height: screenHeight(context) * 0.03),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
