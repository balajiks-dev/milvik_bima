import 'package:flutter/material.dart';
import 'package:milvik_bima/utils/colors.dart';
import 'package:milvik_bima/utils/text_styles.dart';

SnackBar snackBarWidget(String error, {int seconds = 2}) {
  return SnackBar(
    duration: Duration(seconds: seconds),
    backgroundColor: ColorData.kcToastColor,
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(error, style: ktsFontStyle16Regular),
    ),
  );
}
