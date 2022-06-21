import 'package:flutter/cupertino.dart';

import '/utils/text_styles.dart';

class FailureUI extends StatelessWidget {
  final String title;
  final double? height;
  const FailureUI({required this.title, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text(title, style: ktsFontStyle14SemiBoldBlack)),
        ],
      ),
    );
  }
}
