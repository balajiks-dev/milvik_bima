import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  ProfilePage({Key? key, required this.selectedIndex}) : super(key: key);

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    DoctorsResponseModel? doctorsResponseModel;
    bool isEditProfile = false;

    Future<bool> _willPopCallback() async {
      Navigator.pop(context, true);
      return true;
    }

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
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
                firstNameController.text = doctorsResponseModel!.firstName;
                lastNameController.text = doctorsResponseModel!.lastName;
                genderController.text = doctorsResponseModel!.gender;
                heightController.text = doctorsResponseModel!.height;
                weightController.text = doctorsResponseModel!.weight;
              } else if (state is EditProfileState){
                isEditProfile = state.selected;
              } else if (state is UpdateProfileSuccessState){
                isEditProfile = !isEditProfile;
                BlocProvider.of<ProfileBloc>(context).add(InitialProfileEvent(index: selectedIndex));
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
                        Expanded(
                          child: Container(
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
                                    showEditProfileButtonView(context, isEditProfile, selectedIndex),
                                    verticalSpaceTiny,
                                    showProfileView(isEditProfile),
                                  ],
                                ),
                              ),),
                        ),
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
                          Navigator.pop(context, true);
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
      ),
    );
  }

  showEditProfileButtonView(BuildContext context, bool isEditProfile, int selectedIndex){
    return Container(
      height: 60,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: TextButton(
        onPressed: () {
          if(isEditProfile){
            BlocProvider.of<ProfileBloc>(context).add(
                UpdateProfileEvent(index: selectedIndex, firstName: firstNameController.text, lastName: lastNameController.text, gender: genderController.text, contactNumber: contactNumberController.text, height: heightController.text, weight: weightController.text),);
          } else {
          BlocProvider.of<ProfileBloc>(context).add(
              EditProfileEvent(selected: !isEditProfile));
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: ColorData.kcGreenButton,
        ),
        child: Text(
          isEditProfile ? AppStrings.saveProfile : AppStrings.editProfile,
          style: ktsFontStyle14White,
        ),
      ),
    );
  }

  showProfileView(bool isEditProfile){
    return Container(
      color: ColorData.kcGreyBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                AppStrings.personalDetails,
                style: ktsFontStyle16Bold,
              ),
            ),
          ),
          verticalSpaceTiny,
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: ColorData.kcWhite,
            ),
            child: FormBuilderTextField(
              readOnly: !isEditProfile,
              name: "Profile First Name",
              controller: firstNameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              enableInteractiveSelection: false,
              maxLines: 1,
              style: ktsFontStyle16Regular,
              decoration: InputDecoration(
                enabled: true,
                labelText: AppStrings.firstName,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                suffixIcon: null,
                contentPadding: const EdgeInsets.all(15.0),
                labelStyle: ktsFontStyle16Regular,
              ),
            ),
          ),
          verticalSpaceTiny,
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: ColorData.kcWhite,
            ),
            child: FormBuilderTextField(
              readOnly: !isEditProfile,
              name: "Profile Last Name",
              controller: lastNameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              enableInteractiveSelection: false,
              maxLines: 1,
              style: ktsFontStyle16Regular,
              decoration: InputDecoration(
                enabled: true,
                labelText: AppStrings.lastName,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                suffixIcon: null,
                contentPadding: const EdgeInsets.all(15.0),
                labelStyle: ktsFontStyle16Regular,
              ),
            ),
          ),
          verticalSpaceTiny,
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: ColorData.kcWhite,
            ),
            child: FormBuilderTextField(
              readOnly: !isEditProfile,
              name: "Profile Gender",
              controller: genderController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              enableInteractiveSelection: false,
              maxLines: 1,
              style: ktsFontStyle16Regular,
              decoration: InputDecoration(
                enabled: true,
                labelText: AppStrings.gender,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                suffixIcon: null,
                contentPadding: const EdgeInsets.all(15.0),
                labelStyle: ktsFontStyle16Regular,
              ),
            ),
          ),
          verticalSpaceTiny,
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: ColorData.kcWhite,
            ),
            child: FormBuilderTextField(
              readOnly: !isEditProfile,
              name: "Profile Contact Number",
              controller: contactNumberController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              enableInteractiveSelection: false,
              maxLines: 1,
              style: ktsFontStyle16Regular,
              decoration: InputDecoration(
                enabled: true,
                labelText: AppStrings.contactNumber,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                suffixIcon: null,
                contentPadding: const EdgeInsets.all(15.0),
                labelStyle: ktsFontStyle16Regular,
              ),
            ),
          ),
          verticalSpaceTiny,

          // Row(
          //   children: [
          //     Container(
          //       margin: const EdgeInsets.all(10.0),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         color: ColorData.kcWhite,
          //       ),
          //       child: FormBuilderTextField(
          //         readOnly: !isEditProfile,
          //         name: "Profile Height",
          //         controller: heightController,
          //         keyboardType: TextInputType.text,
          //         textInputAction: TextInputAction.done,
          //         enableInteractiveSelection: false,
          //         maxLines: 1,
          //         style: ktsFontStyle16Regular,
          //         decoration: InputDecoration(
          //           enabled: true,
          //           labelText: AppStrings.lastName,
          //           focusedBorder: InputBorder.none,
          //           enabledBorder: InputBorder.none,
          //           suffixIcon: null,
          //           contentPadding: const EdgeInsets.all(15.0),
          //           labelStyle: ktsFontStyle16Regular,
          //         ),
          //       ),
          //     ),
          //     Container(
          //       margin: const EdgeInsets.all(10.0),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         color: ColorData.kcWhite,
          //       ),
          //       child: FormBuilderTextField(
          //         readOnly: !isEditProfile,
          //         name: "Profile Weight",
          //         controller: weightController,
          //         keyboardType: TextInputType.text,
          //         textInputAction: TextInputAction.done,
          //         enableInteractiveSelection: false,
          //         maxLines: 1,
          //         style: ktsFontStyle16Regular,
          //         decoration: InputDecoration(
          //           enabled: true,
          //           labelText: AppStrings.lastName,
          //           focusedBorder: InputBorder.none,
          //           enabledBorder: InputBorder.none,
          //           suffixIcon: null,
          //           contentPadding: const EdgeInsets.all(15.0),
          //           labelStyle: ktsFontStyle16Regular,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}


