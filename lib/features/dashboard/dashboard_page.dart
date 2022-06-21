import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milvik_bima/utils/colors.dart';
import '/utils/constants.dart';
import '/utils/ui_helpers.dart';
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
    String selectedRoom = "";

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: ColorData.kcPrimaryColor,
       // appBar: AppBar(
       //    backgroundColor: ColorData.kcPrimaryColor,
       //    title: const Text(AppStrings.kHome),
      //  ),
      //  drawer: CommonDrawer(userName: userName, emailId: emailId),
        // body: BlocProvider(
        //   create: (context) {
        //     return DashboardBloc()..add(InitialDashboardEvent());
        //   },
        //   child: BlocListener<DashboardBloc, DashboardState>(
        //     listener: (BuildContext context, state) {
        //       if (state is ShowProgressBar) {
        //         DialogBuilder(context).showLoadingIndicator();
        //       } else if (state is DismissProgressBar) {
        //         DialogBuilder(context).hideOpenDialog();
        //       } else if (state is InitialDashboardSuccessState) {
        //         roomsList = state.roomsList;
        //         isLoaded = true;
        //         isScreenLoaded = true;
        //       } else if (state is RoomTypeValueState) {
        //         selectedRoom = state.dropDownValue;
        //       }
        //     },
        //     child: BlocBuilder<DashboardBloc, DashboardState>(
        //         builder: (context, state) {
        //         if(ModalRoute.of(context)!.isCurrent){
        //           if(!isScreenLoaded){
        //           BlocProvider.of<DashboardBloc>(context).add(
        //             InitialDashboardEvent(),
        //           );
        //           }
        //         }
        //         if (state is NetworkFailureState) {
        //           return NetworkFailureUI(
        //               error: state.error,
        //               onPressed: () {
        //                 BlocProvider.of<DashboardBloc>(context).add(
        //                   InitialDashboardEvent(),
        //                 );
        //               });
        //         }
        //         return isLoaded
        //             ? Scaffold(
        //                 backgroundColor: ColorData.kcWhite,
        //                 body: SingleChildScrollView(
        //                   child: Padding(
        //                     padding: const EdgeInsets.all(12.0),
        //                     child: Column(
        //                       children: [
        //                         buildRoomsDropdownWidget(
        //                             screenWidth(context),
        //                             AppStrings.kRooms,
        //                             context,
        //                             selectedRoom,
        //                             roomsList)
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               )
        //             : const FailureUI(title: AppStrings.kNoDataFound);
        //       },
        //     ),
        //   ),
        // ),
      ),
    );
  }
}


