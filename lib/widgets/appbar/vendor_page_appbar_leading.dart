import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodie/widgets/buttons/custom_button.dart';

class VendorPageAppBarLeading extends StatelessWidget {
  const VendorPageAppBarLeading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 40,
      height: 30,
      child: CustomButton(
        child: Icon(
          Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
          size: 16,
        ),
        //close page when use tap on close
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
