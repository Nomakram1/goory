import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/widgets/buttons/custom_button.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      child: Row(
        children: <Widget>[
          Icon(
            FlutterIcons.sound_mix_ent,
            size: 16,
            color: AppColor.iconHintColor,
          ),
          SizedBox(
            width: 5,
          ),
          Text("Filter"),
        ],
      ),
      color: AppColor.inputFillColor,
      onPressed: widget.onPressed,
    );
  }
}
