import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_sizes.dart';
import 'package:Doory/constants/app_text_styles.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    Key key,
    this.hintText,
    this.border,
    this.filled,
    this.isFixedHeight = true,
    this.fillColor,
    this.textEditingController,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.cursorColor,
    this.textStyle,
    this.labelText,
    this.labelTextStyle,
    this.hintTextStyle,
    this.prefixWidget,
    this.suffixWidget,
    this.togglePassword = false,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.nextFocusNode,
    this.isReadOnly = false,
    this.onTap,
  }) : super(key: key);

  final InputBorder border;
  final bool filled;
  final bool isFixedHeight;
  final Color fillColor;
  final TextEditingController textEditingController;
  final bool obscureText;
  final bool togglePassword;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final Color cursorColor;
  final TextStyle textStyle;

  final String labelText;
  final TextStyle labelTextStyle;

  final String hintText;
  final TextStyle hintTextStyle;

  final Widget prefixWidget;
  final Widget suffixWidget;

  final Function onChanged;
  final Function onFieldSubmitted;
  final String errorText;
  final Function validator;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  final bool isReadOnly;
  final Function onTap;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool makePasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: widget.isFixedHeight ? AppSizes.inputHeight : null,
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          decoration: BoxDecoration(
            color: AppColor.inputFillColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            children: <Widget>[
              //show leading widget or empty space if no leading widget was added
              widget.prefixWidget ?? SizedBox.shrink(),

              //add spacing if there is a leading widget
              (widget.prefixWidget != null)
                  ? SizedBox(
                      width: 15,
                    )
                  : SizedBox.shrink(),

              Expanded(
                child: TextFormField(
                  onTap: widget.onTap,
                  readOnly: widget.isReadOnly,
                  controller: widget.textEditingController,
                  focusNode: widget.focusNode,
                  onFieldSubmitted: (data) {
                    if (widget.onFieldSubmitted != null) {
                      widget.onFieldSubmitted(data);
                    } else {
                      FocusScope.of(context).requestFocus(widget.nextFocusNode);
                    }
                  },
                  onChanged: widget.onChanged,
                  obscureText:
                      (widget.obscureText) ? !makePasswordVisible : false,
                  textInputAction: widget.textInputAction,
                  keyboardType: widget.keyboardType,
                  cursorColor: (widget.cursorColor != null)
                      ? widget.cursorColor
                      : AppColor.cursorColor,
                  style: (widget.textStyle != null)
                      ? widget.textStyle
                      : TextStyle(color: Colors.black),
                  validator: widget.validator,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: widget.labelTextStyle,
                    hintStyle: widget.hintTextStyle,
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                  ),
                ),
              ),

              //suffix widget
              if (widget.togglePassword)
                ButtonTheme(
                  minWidth: 30,
                  height: 30,
                  padding: EdgeInsets.all(0),
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        makePasswordVisible = !makePasswordVisible;
                      });
                    },
                    child: Icon(
                      (!makePasswordVisible)
                          ? FlutterIcons.md_eye_off_ion
                          : FlutterIcons.md_eye_ion,
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                SizedBox.shrink(),
            ],
          ),
        ),

        // Error text widget
        widget.errorText != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.errorText,
                  style: AppTextStyle.h6TitleTextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
