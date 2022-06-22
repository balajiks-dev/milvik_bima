import 'package:flutter/material.dart';
import 'package:milvik_bima/utils/assets.dart';
import 'package:milvik_bima/utils/text_styles.dart';

import '../utils/constants.dart';
import '../utils/ui_helpers.dart';

class NetworkFailureUI extends StatelessWidget {
  final String error;
  final VoidCallback? onPressed;
  const NetworkFailureUI({required this.error, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(UIAssets.bimaLogo),
            ),
            Text(error, style: ktsFontStyle14White),
            verticalSpaceLarge,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // background// foreground
              ),
              onPressed: onPressed,
              child: Text(AppStrings.tryAgain, style: ktsFontStyle16Regular),
            ),
          ],
        ),
      ),
    );
  }
}
