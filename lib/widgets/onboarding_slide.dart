import 'package:flutter/material.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:lottie/lottie.dart';

class OnboardingSlide extends StatefulWidget {
  OnboardingSlide({
    Key key,
    @required this.asset,
    @required this.title,
    @required this.description,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.backgroundColor,
  }) : super(key: key);

  final String asset;
  final String title;
  final TextStyle titleTextStyle;
  final String description;
  final TextStyle descriptionTextStyle;
  final Color backgroundColor;

  @override
  _OnboardingSlideState createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<OnboardingSlide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.defaultPadding(),
      color: widget.backgroundColor ?? Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LottieBuilder.asset(
              widget.asset,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            SizedBox(
              height: 40,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                textAlign: TextAlign.left,
                style: widget.titleTextStyle ?? AppTextStyle.h1TitleTextStyle(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.description,
                textAlign: TextAlign.left,
                style: widget.descriptionTextStyle ??
                    AppTextStyle.h3TitleTextStyle(
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
