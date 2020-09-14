import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CoolRadioButtonBuilder<T> {
  final String description;
  final TextStyle textStyle;
  final Widget title;

  CoolRadioButtonBuilder(
    this.description, {
    this.textStyle,
    this.title,
  });
}
