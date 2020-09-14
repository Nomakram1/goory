import 'package:flutter/material.dart';
import 'package:foodie/constants/app_strings.dart';
import 'package:foodie/widgets/inputs/custom_text_form_field.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    @required this.onSearchBarPressed,
    this.onSubmit,
    this.readOnly = false,
    this.focusNode,
  }) : super(key: key);

  final Function onSearchBarPressed;
  final Function onSubmit;
  final bool readOnly;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      isReadOnly: readOnly,
      focusNode: this.focusNode,
      hintText: AppStrings.searchBarHint,
      prefixWidget: Icon(
        Icons.search,
        color: Colors.grey[500],
      ),
      onTap: this.onSearchBarPressed,
      onFieldSubmitted: this.onSubmit,
    );
  }
}
