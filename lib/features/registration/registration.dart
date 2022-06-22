import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:milvik_bima/features/dashboard/dashboard_page.dart';
import 'package:milvik_bima/features/registration/bloc/registration_bloc.dart';
import 'package:milvik_bima/features/registration/bloc/registration_event.dart';
import 'package:milvik_bima/features/registration/bloc/registration_state.dart';
import 'package:milvik_bima/shared_widgets/loading_indicator.dart';
import 'package:milvik_bima/shared_widgets/snack_bar.dart';
import 'package:milvik_bima/utils/colors.dart';
import 'package:milvik_bima/utils/constants.dart';
import 'package:milvik_bima/utils/text_styles.dart';
import 'package:milvik_bima/utils/ui_helpers.dart';

///
/// Define for Registration page
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///
class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> _willPopCallback() async {
      // await showDialog or Show add banners or whatever
      // then
      return false; // return true if the route to be popped
    }
    String mobileNumber = "";
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController phoneNumberController = TextEditingController();

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: ColorData.kcPrimaryDarkColor,
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
              } else if (state is ClearButtonPressedState) {
                mobileNumber = state.mobileNumber;
                phoneNumberController.clear();
              } else if (state is RegistrationFailureState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBarWidget(state.error));
              } else if (state is RegistrationSuccessState) {
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
            child: BlocBuilder<RegistrationBloc, RegistrationState>(
              builder: (context, state) {
                return Scaffold(
                  backgroundColor: ColorData.kcPrimaryDarkColor,
                  body: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight(context) * 0.2),
                        child: Text(AppStrings.enterMobileNumber,
                            style: ktsFontStyle16SemiBoldWhite),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: IntlPhoneField(
                                  showCountryFlag: false,
                                  style: ktsFontStyle20SemiBoldYellow,
                                  dropdownIconPosition: IconPosition.trailing,
                                  dropdownIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: ColorData.kcGreenButton,
                                  ),
                                  dropdownTextStyle: ktsFontStyle20SemiBoldGreen,
                                  controller: phoneNumberController,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          BlocProvider.of<RegistrationBloc>(
                                                  context)
                                              .add(ClearButtonPressed(
                                                  mobileNumber: mobileNumber));
                                        },
                                        icon: const Icon(Icons.clear,
                                            color: ColorData.kcYellowButton),
                                      ),
                                      counterText: "",
                                      prefixStyle: ktsFontStyle20SemiBoldYellow,
                                      labelText: AppStrings.phoneNumber,
                                      counterStyle: ktsFontStyle20SemiBoldYellow,
                                      floatingLabelStyle:
                                      ktsFontStyle20SemiBoldYellow,
                                      errorStyle: ktsFontStyle20SemiBoldYellow,
                                      hintStyle: ktsFontStyle20SemiBoldYellow,
                                      labelStyle: ktsFontStyle20SemiBoldYellow),
                                  onChanged: (phone) {
                                    mobileNumber = "${phone.countryCode} ${phone.number}";
                                    debugPrint(phone.completeNumber);
                                  },
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                                child: Text(AppStrings.smsText, style: ktsFontStyle14White,),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  bottomNavigationBar:  Padding(
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
                          formKey.currentState?.validate();
                          BlocProvider.of<RegistrationBloc>(context).add(
                              RegistrationButtonPressed(
                                  mobileNumber: mobileNumber, context: context));
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => OtpPage()));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: ColorData.kcGreenButton,
                        ),
                        child: Text(
                          AppStrings.continueText,
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
      ),
    );
  }
}
