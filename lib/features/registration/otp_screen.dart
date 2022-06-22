import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milvik_bima/features/registration/bloc/registration_bloc.dart';
import 'package:milvik_bima/features/registration/bloc/registration_event.dart';
import 'package:milvik_bima/features/registration/bloc/registration_state.dart';
import 'package:milvik_bima/features/registration/terms_condition.dart';
import 'package:milvik_bima/shared_widgets/loading_indicator.dart';
import 'package:milvik_bima/shared_widgets/snack_bar.dart';
import 'package:milvik_bima/utils/colors.dart';
import 'package:milvik_bima/utils/constants.dart';
import 'package:milvik_bima/utils/text_styles.dart';
import 'package:milvik_bima/utils/ui_helpers.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../dashboard/dashboard_page.dart';
///
/// Define for OTP Screen
///  @author Balaji Sundaram 22/06/2022.
///  @version 1.0
///
class OtpPage extends StatelessWidget {
  bool isTermsSelected = false;

  OtpPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController otpTextEditingController = TextEditingController();

    return Scaffold(
      backgroundColor: ColorData.kcPrimaryColor,
      body: BlocProvider(
        create: (context) {
          return RegistrationBloc();
        },
        child: BlocListener<RegistrationBloc, RegistrationState>(
          listener: (BuildContext context, state) {
            if (state is DismissProgressBar) {
              DialogBuilder(context).hideOpenDialog();
            } else if (state is ShowProgressBar) {
              DialogBuilder(context).showLoadingIndicator();
            } else if (state is OtpSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
               AppStrings.loginSuccessful,
              ));
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const DashboardPage()),
                  ModalRoute.withName('/'));
            } else if (state is OtpFailureState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBarWidget(state.error));
            } else if (state is TermsConditionState){
              isTermsSelected = state.isTermsChecked;
            }
          },
          child: BlocBuilder<RegistrationBloc, RegistrationState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: ColorData.kcPrimaryColor,
                body: buildMainWidget(context, otpTextEditingController),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 70.0),
                  child: Container(
                    height: 60,
                    width: screenWidth(context) * 0.9,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0)
                    ),
                    child: TextButton(
                      onPressed: () {
                        BlocProvider.of<RegistrationBloc>(context).add(
                            OtpButtonPressed(otp: otpTextEditingController.text, context: context, isTermsSelected: isTermsSelected));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: ColorData.kcGreenButton,
                      ),
                      child: Text(
                        AppStrings.login,
                        style: ktsFontStyle16SemiBoldWhite,
                      ),
                    ),
                  ),
                )
              );
            },
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildMainWidget(
      BuildContext context, TextEditingController otpTextEditingController) {
    final double height = screenHeight(context);
    final double width = screenWidth(context);
    return SingleChildScrollView(
      child: Container(
        height: height - AppBar().preferredSize.height,
        width: width,
        decoration: const BoxDecoration(
          color: ColorData.kcPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        margin: const EdgeInsets.only(top: 5.0),
        child: Container(
          margin: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: Text(AppStrings.enterVerificationCode,
                    style: ktsFontStyle16RegularWhite),
              ),
              verticalSpaceLarge,
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscuringCharacter: '*',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      return null;
                    },
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: ColorData.kcWhite,
                        activeColor: ColorData.kcGreen,
                        inactiveFillColor: ColorData.kcPrimaryColor,
                        inactiveColor: ColorData.kcLightGray,
                        selectedFillColor: ColorData.kcWhite,
                        selectedColor: ColorData.kcGreen),
                    cursorColor: ColorData.kcLightGray,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: otpTextEditingController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {
                      debugPrint("Completed");
                    },
                    onChanged: (value) {
                      debugPrint(value);
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      return true;
                    },
                  )),
              termsConditionWidget(context),

            ],
          ),
        ),
      ),
    );
  }

  Widget termsConditionWidget(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Row(
          children: [
            Checkbox(
                checkColor: ColorData.kcWhite,
                activeColor: ColorData.kcGreenButton,
                value: isTermsSelected,
                onChanged: (newValue) async {
                  FocusScope.of(context).unfocus();
                  BlocProvider.of<RegistrationBloc>(context).add(
                      TermsConditionEvent(isTermsChecked: !isTermsSelected));
                }),
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsAndConditionScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'I agree to the ',
                      style: ktsFontStyle16RegularWhite,
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Terms of Service, ',
                            style: ktsFontStyle16RegularYellow),
                        TextSpan(
                            text: 'Privacy Policy ',
                            style: ktsFontStyle16RegularYellow),
                        const TextSpan(text: '&'),
                        TextSpan(
                            text: ' Refund Policy. ',
                            style: ktsFontStyle16RegularYellow),
                      ],
                    ),
                  )),
            )
          ],
        ));
  }

}
