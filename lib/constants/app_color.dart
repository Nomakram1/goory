import 'package:flutter/material.dart';

class AppColor {
  static final accentColor = Color(0xFF19798A);
  static final primaryColor = Color(0xFF15616D);
  static final primaryColorDark = Color(0xFF104C56);
  static final cursorColor = Color(0xFF15616D);
  static final appBackground = Color(0xFFEEEEEE);
  static final vendorOpenColor = Colors.green[900];

  //onboarding colors
  static final onboarding1Color = Color(0xFFF9F9F9);
  static final onboarding2Color = Color(0xFFF6EFEE);
  static final onboarding3Color = Color(0xFFFFFBFC);

  static final onboardingIndicatorDotColor = Color(0xFF30C0D9);
  static final onboardingIndicatorActiveDotColor = Color(0xFF15616D);

  //Shimmer Colors
  static final shimmerBaseColor = Colors.grey[300];
  static final shimmerHighlightColor = Colors.grey[200];

  //inputs
  static final inputFillColor = Colors.grey[200];
  static final iconHintColor = Colors.grey[500];

  //operation status colors
  static final successfulColor = Colors.green[400];
  static final waringColor = Colors.yellow[700];
  static final failedColor = Colors.red[400];

  //return color base on the status of the order
  static Color statusColor({String status}) {
    if (status.toLowerCase().contains("success") ||
        status.toLowerCase().contains("deliver")) {
      return successfulColor;
    } else if (status.toLowerCase().contains("pending")) {
      return waringColor;
    } else if (status.toLowerCase().contains("fail") ||
        status.toLowerCase().contains("cancel")) {
      return failedColor;
    } else {
      return waringColor;
    }
  }
}
