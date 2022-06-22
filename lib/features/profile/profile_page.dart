import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milvik_bima/features/profile/bloc/profile_bloc.dart';
import 'package:milvik_bima/features/profile/bloc/profile_event.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';
import 'package:milvik_bima/shared_widgets/loading_indicator.dart';
import 'package:milvik_bima/utils/assets.dart';
import 'package:milvik_bima/utils/colors.dart';
import 'package:milvik_bima/utils/text_styles.dart';
import 'package:milvik_bima/utils/ui_helpers.dart';
import '/utils/constants.dart';
import 'bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  final int selectedIndex;
  const ProfilePage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DoctorsResponseModel? doctorsResponseModel;
    return Scaffold(
      backgroundColor: ColorData.kcPrimaryDarkColor,
      body: BlocProvider(
        create: (context) {
          return ProfileBloc()..add(InitialProfileEvent(index: selectedIndex));
        },
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (BuildContext context, state) {
            if (state is ShowProgressBar) {
              DialogBuilder(context).showLoadingIndicator();
            } else if (state is DismissProgressBar) {
              DialogBuilder(context).hideOpenDialog();
            } else if (state is InitialProfileSuccessState){
              doctorsResponseModel = state.doctorModel;
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
              return
                doctorsResponseModel != null ?
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 80.0,
                        color: ColorData.kcPrimaryDarkColor,
                      ),
                      Container(
                        width: screenWidth(context),
                          decoration: const BoxDecoration(
                            color: ColorData.kcWhite,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Column(
                              children: [
                                verticalSpaceLarge,
                                Text(
                                  "${doctorsResponseModel!
                                      .firstName} ${doctorsResponseModel!.lastName}".toUpperCase(),
                                  style: ktsFontStyle16Bold,
                                ),
                                verticalSpaceTiny,
                                showEditProfileButtonView(),
                                verticalSpaceTiny,
                                showProfileView(),
                              ],
                            ),
                          ),),
                    ],
                  ),
                  // Profile image
                  Positioned(
                      top: 50.0,
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                          backgroundImage: NetworkImage(doctorsResponseModel!.profilePic,
                          )
                      ),
                  ),
                  Positioned(
                    left: 10.0,
                    top: 25.0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: ColorData.kcYellowButton,),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ) : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 40.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: ColorData.kcYellowButton,),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight(context) * 0.4),
                    child: Center(
                      child: Text(AppStrings.noDataFound, style: ktsFontStyle16Regular,),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  showEditProfileButtonView(){
    return Container(
      height: 60,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: TextButton(
        onPressed: () {
          // BlocProvider.of<RegistrationBloc>(context).add(
          //     RegistrationButtonPressed(
          //         mobileNumber: mobileNumber, context: context));

        },
        style: TextButton.styleFrom(
          backgroundColor: ColorData.kcGreenButton,
        ),
        child: Text(
          AppStrings.editProfile,
          style: ktsFontStyle14White,
        ),
      ),
    );
  }

  showProfileView(){
    return Container(
      color: ColorData.kcWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              AppStrings.personalDetails,
              style: ktsFontStyle16Bold,
            ),
          ),
        ],
      ),
    );
  }
}


