import 'package:flutter/material.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_paddings.dart';

class CustomOutlineButton extends StatefulWidget {
  CustomOutlineButton({
    Key key,
    this.onPressed,
    this.child,
    this.textColor,
    this.disabledTextColor,
    this.color,
    this.disabledColor,
    this.padding,
  }) : super(key: key);

  final Function onPressed;
  final Widget child;
  final Color textColor;
  final Color disabledTextColor;
  final Color color;
  final Color disabledColor;
  final EdgeInsets padding;
  @override
  _CustomOutlineButtonState createState() => _CustomOutlineButtonState();
}

class _CustomOutlineButtonState extends State<CustomOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      // padding: widget.padding ?? EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: widget.padding ?? AppPaddings.buttonPadding(),
      disabledTextColor: widget.disabledTextColor,
      textColor: widget.textColor ?? Colors.black,
      shape: StadiumBorder(),
      borderSide: BorderSide(
        color: AppColor.accentColor,
      ),
      highlightColor: AppColor.accentColor,
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}
