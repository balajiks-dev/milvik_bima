import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milvik_bima/features/profile/profile_page.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';
import 'package:milvik_bima/shared_widgets/common_drawer.dart';
import 'package:milvik_bima/shared_widgets/failure.dart';
import 'package:milvik_bima/shared_widgets/loading_indicator.dart';
import 'package:milvik_bima/shared_widgets/network_failure.dart';
import 'package:milvik_bima/utils/assets.dart';
import 'package:milvik_bima/utils/colors.dart';
import 'package:milvik_bima/utils/text_styles.dart';

import '/utils/constants.dart';
import 'bloc/dashboard_bloc.dart';
import 'bloc/dashboard_event.dart';
import 'bloc/dashboard_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    bool isLoaded = false;
    bool isScreenLoaded = false;
    List<DoctorsResponseModel> doctorsList = <DoctorsResponseModel>[];
    List<DoctorsResponseModel> topRatedDoctorsList = <DoctorsResponseModel>[];

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: ColorData.kcPrimaryColor,
        appBar: AppBar(
          backgroundColor: ColorData.kcPrimaryColor,
          title: Text(
            AppStrings.bimaDoctor,
            style: ktsFontStyle16PrimarySemiBold,
          ),
          actions: [
            Image.asset(
              UIAssets.bimaLogo,
              fit: BoxFit.contain,
            )
          ],
        ),
        drawer: const CommonDrawer(userName: '', emailId: ''),
        body: BlocProvider(
          create: (context) {
            return DashboardBloc()..add(InitialDashboardEvent());
          },
          child: BlocListener<DashboardBloc, DashboardState>(
            listener: (BuildContext context, state) {
              if (state is ShowProgressBar) {
                DialogBuilder(context).showLoadingIndicator();
              } else if (state is DismissProgressBar) {
                DialogBuilder(context).hideOpenDialog();
              } else if (state is InitialDashboardSuccessState) {
                doctorsList.clear();
                doctorsList = state.doctorsList;
                topRatedDoctorsList.clear();
                if (doctorsList.length > 3) {
                  for (int i = 0; i < 3; i++) {
                    topRatedDoctorsList.add(doctorsList[i]);
                  }
                } else {
                  topRatedDoctorsList = doctorsList;
                }
                isLoaded = true;
                isScreenLoaded = true;
              }
            },
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (ModalRoute.of(context)!.isCurrent) {
                  if (!isScreenLoaded) {
                    BlocProvider.of<DashboardBloc>(context).add(
                      InitialDashboardEvent(),
                    );
                  }
                }
                if (state is NetworkFailureState) {
                  return NetworkFailureUI(
                      error: state.error,
                      onPressed: () {
                        BlocProvider.of<DashboardBloc>(context).add(
                          InitialDashboardEvent(),
                        );
                      });
                }
                return isLoaded
                    ? Scaffold(
                        backgroundColor: ColorData.kcWhite,
                        body: Column(
                          children: [
                            // Visibility(
                            //   visible: doctorsList.isNotEmpty,
                            //   child: Container(
                            //     height: screenHeight(context) * 0.3,
                            //     width: screenWidth(context) * 0.9,
                            //     child: CarouselSlider(
                            //       items: showTopRatedDoctorView(topRatedDoctorsList),
                            //       options: CarouselOptions(
                            //           viewportFraction: 1,
                            //         autoPlay: true,
                            //         scrollDirection: Axis.horizontal,
                            //           autoPlayInterval: const Duration(seconds: 1)
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: doctorsList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage(
                                                          selectedIndex: index),
                                                ),
                                              );
                                            },
                                            child: showDoctorCardView(
                                                doctorsList[index])),
                                        const Divider()
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ))
                    : const FailureUI(title: AppStrings.noDataFound);
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> showTopRatedDoctorView(
      List<DoctorsResponseModel> topRatedDoctorsList) {
    List<Widget> topRatedDoctorCardView = <Widget>[];
    for (int i = 0; i < topRatedDoctorsList.length; i++) {
      topRatedDoctorCardView.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 30, // Image radius
                backgroundImage:
                    NetworkImage(topRatedDoctorsList[i].profilePic)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 10.0, 5.0, 2.0),
                    child: Text(
                      "${topRatedDoctorsList[i].firstName} ${topRatedDoctorsList[i].lastName}",
                      style: ktsFontStyle16PrimarySemiBold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 5.0, 2.0),
                    child: Text(
                      topRatedDoctorsList[i].qualification,
                      style: ktsFontStyle14PrimaryRegular,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 10.0, 5.0, 2.0),
                    child: Text("Star Rating: ${topRatedDoctorsList[i].rating}",
                        style: ktsFontStyle14RegularBlack),
                  )
                ],
              ),
            ),
          ],
        ),
      ));
    }
    return topRatedDoctorCardView;
  }

  showDoctorCardView(DoctorsResponseModel doctorModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
              radius: 30, // Image radius
              backgroundImage: NetworkImage(doctorModel.profilePic)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 10.0, 5.0, 2.0),
                  child: Text(
                    "${doctorModel.firstName} ${doctorModel.lastName}",
                    style: ktsFontStyle16PrimarySemiBold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 5.0, 2.0),
                  child: Text(
                    doctorModel.specialization,
                    style: ktsFontStyle14PrimaryRegular,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 10.0, 5.0, 2.0),
                  child: Text(
                    doctorModel.description,
                    style: ktsFontStyle14RegularBlack,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: ColorData.kcPrimaryColor,
          )
        ],
      ),
    );
  }
}
