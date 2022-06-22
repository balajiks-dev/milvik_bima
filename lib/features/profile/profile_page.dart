import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milvik_bima/features/profile/bloc/profile_bloc.dart';
import 'package:milvik_bima/model/doctors_response_model.dart';
import 'package:milvik_bima/shared_widgets/loading_indicator.dart';
import 'package:milvik_bima/utils/assets.dart';
import 'package:milvik_bima/utils/colors.dart';
import 'package:milvik_bima/utils/text_styles.dart';
import '/utils/constants.dart';
import 'bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorData.kcPrimaryColor,
     appBar: AppBar(
        backgroundColor: ColorData.kcPrimaryColor,
        title: Text(AppStrings.bimaDoctor, style: ktsFontStyle16PrimarySemiBold,),
       actions: [
         Image.asset(UIAssets.bimaLogo, fit: BoxFit.contain,)
       ],
     ),
      body: BlocProvider(
        create: (context) {
          return ProfileBloc();
        },
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (BuildContext context, state) {
            if (state is ShowProgressBar) {
              DialogBuilder(context).showLoadingIndicator();
            } else if (state is DismissProgressBar) {
              DialogBuilder(context).hideOpenDialog();
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
              return Scaffold(
                      backgroundColor: ColorData.kcPrimaryColor,
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back, color: ColorData.kcYellow,)
                          ),
                        ],
                      )
                    );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> showTopRatedDoctorView(List<DoctorsResponseModel> topRatedDoctorsList){
    List<Widget> topRatedDoctorCardView = <Widget>[];
    for(int i = 0; i < topRatedDoctorsList.length; i++){
      topRatedDoctorCardView.add(
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                    radius: 30, // Image radius
                    backgroundImage: NetworkImage(topRatedDoctorsList[i].profilePic)
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 10.0, 5.0, 2.0),
                        child: Text("${topRatedDoctorsList[i].firstName} ${topRatedDoctorsList[i].lastName}", style: ktsFontStyle16PrimarySemiBold,),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 5.0, 2.0),
                        child: Text(topRatedDoctorsList[i].qualification, style: ktsFontStyle14PrimaryRegular,),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 10.0, 5.0, 2.0),
                        child: Text("Star Rating: ${topRatedDoctorsList[i].rating}", style: ktsFontStyle14RegularBlack),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
      );
    }
    return topRatedDoctorCardView;
  }

  showDoctorCardView(DoctorsResponseModel doctorModel){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 30, // Image radius
            backgroundImage: NetworkImage(doctorModel.profilePic)
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 10.0, 5.0, 2.0),
                  child: Text("${doctorModel.firstName} ${doctorModel.lastName}", style: ktsFontStyle16PrimarySemiBold,),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 5.0, 2.0),
                  child: Text(doctorModel.specialization, style: ktsFontStyle14PrimaryRegular,),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 10.0, 5.0, 2.0),
                  child: Text(doctorModel.description, style: ktsFontStyle14RegularBlack, maxLines: 2, overflow: TextOverflow.ellipsis,),
                )
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: ColorData.kcPrimaryColor,)
        ],
      ),
    );
  }
}


