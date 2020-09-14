import 'package:flutter/material.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:lottie/lottie.dart';

class OrderStatusPage extends StatelessWidget {
  OrderStatusPage({
    Key key,
    this.successful = true,
  }) : super(key: key);

  final bool successful;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.light,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: AppPaddings.defaultPadding(),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.28,
            ),
            child: Column(
              children: <Widget>[
                LottieBuilder.asset(
                  successful
                      ? "assets/animations/lottie/success.json"
                      : "assets/animations/lottie/checkout_failed.json",
                  height: MediaQuery.of(context).size.height * 0.20,
                  repeat: false,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  successful ? "Order Completed" : "Order Failed",
                  style: AppTextStyle.h2TitleTextStyle(),
                  textAlign: TextAlign.center,
                ),
                Text(
                  successful
                      ? "Your order has been placed. You will be notified shortly \n😉😉😉😉😉"
                      : "There was an issue processing your order. Please try again later\n😟😟😟😟😟",
                  style: AppTextStyle.h5TitleTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
