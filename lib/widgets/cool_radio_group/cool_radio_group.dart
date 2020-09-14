import 'package:flutter/material.dart';
import 'package:foodie/widgets/cool_radio_group/cool_radio_group_builder.dart';

class CoolRadioGroup<T> extends StatelessWidget {
  const CoolRadioGroup.builder({
    Key key,
    @required this.selectedValue,
    @required this.items,
    @required this.itemBuilder,
    @required this.onChanged,
    this.spacebetween = 5,
    this.direction = Axis.vertical,
    this.horizontalAlignment = MainAxisAlignment.spaceBetween,
  }) : super(key: key);

  final T selectedValue;
  final List<T> items;
  final CoolRadioButtonBuilder Function(T value) itemBuilder;
  final void Function(T) onChanged;
  final double spacebetween;
  final Axis direction;
  final MainAxisAlignment horizontalAlignment;

  List<Widget> get _group => this.items.map(
        (item) {
          final radioButtonBuilder = this.itemBuilder(item);
          final radioButtonWidget = Container(
            margin: EdgeInsets.only(
              bottom: spacebetween,
            ),
            child: RadioListTile(
              title: radioButtonBuilder.title ??
                  Text(
                    radioButtonBuilder.description,
                    style: radioButtonBuilder.textStyle,
                  ),
              value: item,
              groupValue: this.selectedValue,
              onChanged: this.onChanged,
            ),
          );

          return radioButtonWidget;
        },
      ).toList();

  @override
  Widget build(BuildContext context) {
    return this.direction == Axis.vertical
        ? Column(
            children: _group,
          )
        : Row(
            mainAxisAlignment: this.horizontalAlignment,
            children: _group,
          );
  }
}
