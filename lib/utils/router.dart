import 'package:flutter/material.dart';
import 'package:Doory/constants/app_routes.dart';
import 'package:Doory/views/auth/forgot_password_page.dart';
import 'package:Doory/views/auth/login_page.dart';
import 'package:Doory/views/auth/onboarding_page.dart';
import 'package:Doory/views/auth/register_page.dart';
import 'package:Doory/views/category_vendors_page.dart';
import 'package:Doory/views/checkout_page.dart';
import 'package:Doory/views/delivery%20address/delivery_addresses_page.dart';
import 'package:Doory/views/delivery%20address/edit_delivery_address_page.dart';
import 'package:Doory/views/home_page.dart';
import 'package:Doory/views/delivery%20address/new_delivery_address_page.dart';
import 'package:Doory/views/profile/change_password_page.dart';
import 'package:Doory/views/profile/edit_profile_page.dart';
import 'package:Doory/views/profile/notifications_page.dart';
import 'package:Doory/views/search_vendors_page.dart';
import 'package:Doory/views/webview.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.welcomeRoute:
      return MaterialPageRoute(builder: (context) => OnboardingPage());

    case AppRoutes.loginRoute:
      return MaterialPageRoute(builder: (context) => LoginPage());
    case AppRoutes.registerRoute:
      return MaterialPageRoute(builder: (context) => RegisterPage());

    case AppRoutes.forgotPasswordRoute:
      return MaterialPageRoute(builder: (context) => ForgotPasswordPage());

    case AppRoutes.homeRoute:
      return MaterialPageRoute(builder: (context) => HomePage());

    case AppRoutes.searchVendorsPage:
      return MaterialPageRoute(builder: (context) => SearchVendorsPage());
    case AppRoutes.categoryVendorsRoute:
      return MaterialPageRoute(
        builder: (context) => CategoryVendorsPage(
          category: settings.arguments,
        ),
      );

    case AppRoutes.newDeliveryAddressRoute:
      return MaterialPageRoute(builder: (context) => NewDeliveryAddressPage());

    case AppRoutes.editDeliveryAddressRoute:
      return MaterialPageRoute(
        builder: (context) => EditDeliveryAddressPage(
          deliveryAddress: settings.arguments,
        ),
      );

    case AppRoutes.deliveryAddressesRoute:
      return MaterialPageRoute(builder: (context) => DeliveryAddressesPage());

    case AppRoutes.checkOutRoute:
      return MaterialPageRoute(builder: (context) => CheckoutPage());

    case AppRoutes.editProfileRoute:
      return MaterialPageRoute(builder: (context) => EditProfilePage());

    case AppRoutes.changePasswordRoute:
      return MaterialPageRoute(builder: (context) => ChangePasswordPage());

    case AppRoutes.notificationsRoute:
      return MaterialPageRoute(builder: (context) => NotificationsPage());

    case AppRoutes.webViewRoute:
      return MaterialPageRoute(
        builder: (context) => WebView(
          url: settings.arguments,
        ),
      );

    default:
      return MaterialPageRoute(builder: (context) => OnboardingPage());
  }
}
