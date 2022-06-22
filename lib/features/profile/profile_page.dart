import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milvik_bima/features/profile/bloc/profile_bloc.dart';
import 'package:milvik_bima/features/profile/bloc/profile_event.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';
import 'package:milvik_bima/shared_widgets/custom_date_picker.dart';
import 'package:milvik_bima/shared_widgets/loading_indicator.dart';
import 'package:milvik_bima/utils/colors.dart';
import 'package:milvik_bima/utils/text_styles.dart';
import 'package:milvik_bima/utils/ui_helpers.dart';

import '/utils/constants.dart';
import 'bloc/profile_state.dart';

///
/// Define for Profile Page
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///

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
  int birthDay = 1;
  int birthMonth = 1;
  int birthYear = 1900;

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
            return ProfileBloc()
              ..add(InitialProfileEvent(index: selectedIndex));
          },
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (BuildContext context, state) {
              if (state is ShowProgressBar) {
                DialogBuilder(context).showLoadingIndicator();
              } else if (state is DismissProgressBar) {
                DialogBuilder(context).hideOpenDialog();
              } else if (state is InitialProfileSuccessState) {
                doctorsResponseModel = state.doctorModel;
                firstNameController.text = doctorsResponseModel!.firstName;
                lastNameController.text = doctorsResponseModel!.lastName;
                genderController.text = doctorsResponseModel!.gender;
                heightController.text = doctorsResponseModel!.height;
                weightController.text = doctorsResponseModel!.weight;
                contactNumberController.text =
                    doctorsResponseModel!.primaryContactNo;
                bloodGroupController.text =
                    doctorsResponseModel!.bloodGroupName;
                birthDay = doctorsResponseModel!.birthDay;
                birthMonth = doctorsResponseModel!.birthMonth;
                birthYear = doctorsResponseModel!.birthYear;
              } else if (state is EditProfileState) {
                isEditProfile = state.selected;
              } else if (state is UpdateProfileSuccessState) {
                isEditProfile = !isEditProfile;
                BlocProvider.of<ProfileBloc>(context)
                    .add(InitialProfileEvent(index: selectedIndex));
              } else if (state is DateofBirthChangeState) {
                birthDay = state.birthDay;
                birthMonth = state.birthMonth;
                birthYear = state.birthYear;
              }
            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return doctorsResponseModel != null
                    ? SingleChildScrollView(
                        child: Stack(
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
                                          "${doctorsResponseModel!.firstName} ${doctorsResponseModel!.lastName}"
                                              .toUpperCase(),
                                          style: ktsFontStyle16Bold,
                                        ),
                                        verticalSpaceTiny,
                                        showEditProfileButtonView(context,
                                            isEditProfile, selectedIndex),
                                        verticalSpaceTiny,
                                        showProfileView(isEditProfile, context),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Profile image
                            Positioned(
                              top: 50.0,
                              child: InkWell(
                                onTap: () {
                                  if (isEditProfile) {
                                    _showPicker(context);
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: doctorsResponseModel!.profilePic
                                          .contains("http")
                                      ? SizedBox(
                                          height: 85,
                                          width: 85,
                                          child: CachedNetworkImage(
                                              imageUrl: doctorsResponseModel!
                                                  .profilePic,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) {
                                                return Container(
                                                  color: ColorData.kcWhite,
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 50,
                                                    ),
                                                  ),
                                                );
                                              },
                                              errorWidget:
                                                  (context, url, error) {
                                                return const Icon(
                                                  Icons.person,
                                                  size: 50,
                                                );
                                              }),
                                        )
                                      : SizedBox(
                                          height: 85,
                                          width: 85,
                                          child: Image.file(
                                              File(doctorsResponseModel!
                                                  .profilePic),
                                              fit: BoxFit.cover),
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10.0,
                              top: 25.0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: ColorData.kcYellowButton,
                                ),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 40.0),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: ColorData.kcYellowButton,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: screenHeight(context) * 0.4),
                            child: Center(
                              child: Text(
                                AppStrings.noDataFound,
                                style: ktsFontStyle16Regular,
                              ),
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

  ///Show the Picker for selecting image from Camera/Gallery
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library,
                        color: ColorData.kcPrimaryColor),
                    title: Text(AppStrings.gallery,
                        style: ktsFontStyle14PrimaryRegular),
                    onTap: () {
                      final pickedFile = _imgFromGallery(context);
                      if (pickedFile != null) {
                        BlocProvider.of<ProfileBloc>(context).add(
                            ProfilePictureAddEvent(
                                image: File(pickedFile.path),
                                index: selectedIndex));
                      } else {
                        BlocProvider.of<ProfileBloc>(context)
                            .add(ProfilePictureNotAddEvent());
                      }
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera,
                      color: ColorData.kcPrimaryColor),
                  title: Text(AppStrings.camera,
                      style: ktsFontStyle14PrimaryRegular),
                  onTap: () {
                    final pickedFile = _imgFromCamera(context);
                    if (pickedFile != null) {
                      BlocProvider.of<ProfileBloc>(context).add(
                          ProfilePictureAddEvent(
                              image: File(pickedFile.path),
                              index: selectedIndex));
                    } else {
                      BlocProvider.of<ProfileBloc>(context)
                          .add(ProfilePictureNotAddEvent());
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _imgFromCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
  }

  _imgFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    return await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
  }

  showEditProfileButtonView(
      BuildContext context, bool isEditProfile, int selectedIndex) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
      child: TextButton(
        onPressed: () {
          if (isEditProfile) {
            BlocProvider.of<ProfileBloc>(context).add(
              UpdateProfileEvent(
                  index: selectedIndex,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  gender: genderController.text,
                  contactNumber: contactNumberController.text,
                  height: heightController.text,
                  weight: weightController.text,
                  bloodGroupName: bloodGroupController.text,
                  birthDay: birthDay,
                  birthMonth: birthMonth,
                  birthYear: birthYear),
            );
          } else {
            BlocProvider.of<ProfileBloc>(context)
                .add(EditProfileEvent(selected: !isEditProfile));
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

  showProfileView(bool isEditProfile, BuildContext context) {
    return Container(
      color: ColorData.kcGreyBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showPersonalDetailTextView(),
          verticalSpaceTiny,
          showFirstNameView(isEditProfile),
          verticalSpaceTiny,
          showLastNameView(isEditProfile),
          verticalSpaceTiny,
          showProfileGenderView(isEditProfile),
          verticalSpaceTiny,
          showContactNumberView(),
          verticalSpaceTiny,
          showDateOfBirthView(isEditProfile, context),
          verticalSpaceTiny,
          showCommonView(isEditProfile),
          verticalSpaceMedium
        ],
      ),
    );
  }

  Column showDateOfBirthView(bool isEditProfile, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppStrings.dateOfBirth,
            style: ktsFontStyle16RegularGrawy,
          ),
        ),
        verticalSpaceTiny,
        DropdownDatePicker(
          isEditable: isEditProfile,
          textStyle: ktsFontStyle16Regular,
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          isDropdownHideUnderline: true,
          isFormValidator: true,
          startYear: 1900,
          endYear: 2022,
          width: 10,
          selectedDay: birthDay,
          selectedMonth: birthMonth, // optional
          selectedYear: birthYear, // optional
          onChangedDay: (value) {
            debugPrint('onChangedDay: $value');
            BlocProvider.of<ProfileBloc>(context).add(
              DateofBirthChangeEvent(
                  birthDay:
                      value != null && value.isNotEmpty ? int.parse(value) : 1,
                  birthYear: birthYear,
                  birthMonth: birthMonth),
            );
          },
          isExpanded: false, // optional default is true
          onChangedMonth: (value) {
            debugPrint('onChangedMonth: $value');
            BlocProvider.of<ProfileBloc>(context).add(
              DateofBirthChangeEvent(
                  birthDay: birthDay,
                  birthMonth:
                      value != null && value.isNotEmpty ? int.parse(value) : 1,
                  birthYear: birthYear),
            );
          },
          onChangedYear: (value) {
            debugPrint('onChangedYear: $value');
            BlocProvider.of<ProfileBloc>(context).add(
              DateofBirthChangeEvent(
                birthDay: birthDay,
                birthMonth: birthMonth,
                birthYear:
                    value != null && value.isNotEmpty ? int.parse(value) : 1900,
              ),
            );
          },
        ),
      ],
    );
  }

  Container showContactNumberView() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: ColorData.kcWhite,
      ),
      child: FormBuilderTextField(
        readOnly: true,
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
          labelStyle: ktsFontStyle16RegularGrawy,
        ),
      ),
    );
  }

  Container showProfileGenderView(bool isEditProfile) {
    return Container(
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
          labelStyle: ktsFontStyle16RegularGrawy,
        ),
      ),
    );
  }

  Container showLastNameView(bool isEditProfile) {
    return Container(
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
          labelStyle: ktsFontStyle16RegularGrawy,
        ),
      ),
    );
  }

  Container showFirstNameView(bool isEditProfile) {
    return Container(
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
          labelStyle: ktsFontStyle16RegularGrawy,
        ),
      ),
    );
  }

  Center showPersonalDetailTextView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Text(
          AppStrings.personalDetails,
          style: ktsFontStyle16Bold,
        ),
      ),
    );
  }

  Row showCommonView(bool isEditProfile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: ColorData.kcWhite,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bloodtype,
                            color: ColorData.kcGrayShade_1,
                          ),
                          Expanded(
                            child: Text(
                              AppStrings.bloodGroup,
                              maxLines: 2,
                              style: ktsFontStyle12RegularGrawy,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    isEditProfile
                        ? Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20.0, left: 10, right: 10),
                            child: TextField(
                              controller: bloodGroupController,
                              style: ktsFontStyle16Regular,
                              decoration: InputDecoration(
                                labelStyle: ktsFontStyle16Regular,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorData.kcPrimaryDarkColor),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorData.kcPrimaryDarkColor),
                                ),
                              ),
                            ),
                          )
                        : Text(bloodGroupController.text,
                            style: ktsFontStyle16Regular),
                  ],
                ),
              )),
        ),
        Expanded(
          child: Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: ColorData.kcWhite,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.height_outlined,
                            color: ColorData.kcGrayShade_1,
                          ),
                          Expanded(
                            child: Text(
                              AppStrings.height,
                              maxLines: 1,
                              style: ktsFontStyle12RegularGrawy,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    isEditProfile
                        ? Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20.0, left: 10, right: 10),
                            child: TextField(
                              controller: heightController,
                              style: ktsFontStyle16Regular,
                              decoration: InputDecoration(
                                labelStyle: ktsFontStyle16Regular,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorData.kcPrimaryDarkColor),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorData.kcPrimaryDarkColor),
                                ),
                              ),
                            ),
                          )
                        : Text(
                            heightController.text,
                            style: ktsFontStyle16Regular,
                          ),
                    verticalSpaceSmall,
                  ],
                ),
              )),
        ),
        Expanded(
          child: Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: ColorData.kcWhite,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.line_weight,
                            color: ColorData.kcGrayShade_1,
                          ),
                          Expanded(
                            child: Text(
                              AppStrings.weight,
                              maxLines: 1,
                              style: ktsFontStyle12RegularGrawy,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    isEditProfile
                        ? Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20.0, left: 10, right: 10),
                            child: TextField(
                              controller: weightController,
                              style: ktsFontStyle16Regular,
                              decoration: InputDecoration(
                                labelStyle: ktsFontStyle16Regular,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorData.kcPrimaryDarkColor),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorData.kcPrimaryDarkColor),
                                ),
                              ),
                            ),
                          )
                        : Text(
                            weightController.text,
                            style: ktsFontStyle16Regular,
                          ),
                    verticalSpaceSmall,
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
