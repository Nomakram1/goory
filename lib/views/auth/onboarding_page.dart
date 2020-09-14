import 'package:flutter/material.dart';
import 'package:foodie/constants/app_animations.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_routes.dart';
import 'package:foodie/constants/strings/onboarding.strings.dart';
import 'package:foodie/widgets/cool_onboarding.dart';
import 'package:foodie/widgets/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({
    Key key,
  }) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  void _completedOnboarding() {
    //route to login page
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.loginRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CoolOnboarding(
        onSkipPressed: _completedOnboarding,
        onCompletedPressed: _completedOnboarding,
        indicatorDotColor: AppColor.onboardingIndicatorDotColor,
        indicatorActiveDotColor: AppColor.onboardingIndicatorActiveDotColor,
        onBoardingSlides: [
          OnboardingSlide(
            asset: AppAnimations.onboarding1,
            title: OnboardingStrings.onboarding1Title,
            description: OnboardingStrings.onboarding1Body,
            backgroundColor: AppColor.onboarding1Color,
          ),
          OnboardingSlide(
            asset: AppAnimations.onboarding2,
            title: OnboardingStrings.onboarding2Title,
            description: OnboardingStrings.onboarding2Body,
            backgroundColor: AppColor.onboarding2Color,
          ),
          OnboardingSlide(
            asset: AppAnimations.onboarding4,
            title: OnboardingStrings.onboarding3Title,
            description: OnboardingStrings.onboarding3Body,
            backgroundColor: AppColor.onboarding3Color,
          ),
        ],
      ),
    );
  }
}
