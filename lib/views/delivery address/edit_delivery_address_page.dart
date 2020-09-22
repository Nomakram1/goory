import 'package:flutter/material.dart';
import 'package:Doory/bloc/base.bloc.dart';
import 'package:Doory/bloc/edit_delivery_address.bloc.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/constants/strings/general.strings.dart';
import 'package:Doory/constants/strings/profile/delivery_address.strings.dart';
import 'package:Doory/constants/strings/profile/edit_delivery_address.strings.dart';
import 'package:Doory/data/models/deliver_address.dart';
import 'package:Doory/utils/custom_dialog.dart';
import 'package:Doory/utils/ui_spacer.dart';
import 'package:Doory/widgets/appbar/leading_app_bar.dart';
import 'package:Doory/widgets/buttons/custom_button.dart';
import 'package:Doory/widgets/buttons/outline_custom_button.dart';
import 'package:Doory/widgets/inputs/custom_text_form_field.dart';
import 'package:Doory/widgets/platform/platform_circular_progress_indicator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

class EditDeliveryAddressPage extends StatefulWidget {
  EditDeliveryAddressPage({
    Key key,
    this.deliveryAddress,
  }) : super(key: key);

  final DeliveryAddress deliveryAddress;
  @override
  _EditDeliveryAddressPageState createState() =>
      _EditDeliveryAddressPageState();
}

class _EditDeliveryAddressPageState extends State<EditDeliveryAddressPage> {
  //delivery address bloc
  EditDeliveryAddressBloc _editDeliveryAddressBloc = EditDeliveryAddressBloc();

  @override
  void initState() {
    super.initState();

    _editDeliveryAddressBloc.initBloc(deliveryAddress: widget.deliveryAddress);

    //listen to the need to show a dialog alert type
    _editDeliveryAddressBloc.showDialogAlert.listen(
      (show) {
        //when asked to show an alert
        if (show) {
          CustomDialog.showAlertDialog(
            context,
            _editDeliveryAddressBloc.dialogData,
            isDismissible: true,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        leading: LeadingAppBar(),
      ),
      body: ListView(
        padding: AppPaddings.defaultPadding(),
        children: <Widget>[
          //header
          Text(
            EditDeliveryaAddressStrings.title,
            style: AppTextStyle.h2TitleTextStyle(),
          ),
          UiSpacer.verticalSpace(space: 5),
          Text(
            EditDeliveryaAddressStrings.instruction,
            style: AppTextStyle.h5TitleTextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          UiSpacer.verticalSpace(space: 40),

          //form section
          StreamBuilder<bool>(
            stream: _editDeliveryAddressBloc.validDeliveryAddressName,
            builder: (context, snapshot) {
              return CustomTextFormField(
                isFixedHeight: false,
                labelText: GeneralStrings.name,
                hintText: GeneralStrings.deliveryAddresNameHint,
                errorText: snapshot.error,
                onChanged: _editDeliveryAddressBloc.validateDeliveryAddressName,
                textEditingController:
                    _editDeliveryAddressBloc.deliveryAddressNameTEC,
              );
            },
          ),

          //select delivery address info
          StreamBuilder<LocationResult>(
            stream: _editDeliveryAddressBloc.selectedLocationResult,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.hasError) {
                return UiSpacer.horizontalSpace(space: 0);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UiSpacer.verticalSpace(),
                  Text(
                    DeliveryaAddressStrings.selectedAddress,
                    style: AppTextStyle.h4TitleTextStyle(),
                  ),
                  Text(
                    snapshot.data.address,
                    style: AppTextStyle.h5TitleTextStyle(),
                  ),
                  UiSpacer.verticalSpace(),
                  //address corrdinates label
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          DeliveryaAddressStrings.latitude,
                          style: AppTextStyle.h4TitleTextStyle(),
                        ),
                      ),
                      UiSpacer.horizontalSpace(),
                      Expanded(
                        flex: 1,
                        child: Text(
                          DeliveryaAddressStrings.longitude,
                          style: AppTextStyle.h4TitleTextStyle(),
                        ),
                      ),
                    ],
                  ),

                  //address corrdinates
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          snapshot.data.latLng.latitude.toString(),
                          style: AppTextStyle.h5TitleTextStyle(),
                        ),
                      ),
                      UiSpacer.horizontalSpace(),
                      Expanded(
                        flex: 1,
                        child: Text(
                          snapshot.data.latLng.longitude.toString(),
                          style: AppTextStyle.h5TitleTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          UiSpacer.verticalSpace(),
          //Location picker button
          StreamBuilder<UiState>(
              stream: _editDeliveryAddressBloc.uiState,
              builder: (context, snapshot) {
                //ui state
                final uiState = snapshot.data;

                return CustomOutlineButton(
                  padding: AppPaddings.mediumButtonPadding(),
                  child: Text(
                    DeliveryaAddressStrings.pickLocation,
                    style: AppTextStyle.h4TitleTextStyle(
                      color: AppColor.primaryColor,
                    ),
                  ),
                  onPressed: uiState != UiState.loading
                      ? _pickNewDeliveryAddress
                      : null,
                  color: AppColor.primaryColor,
                );
              }),
          UiSpacer.verticalSpace(space: 40),
          //show info of the just picked address
          StreamBuilder<bool>(
            stream: _editDeliveryAddressBloc.canSave,
            builder: (context, snapshot) {
              //saving the value for future refrenece
              final canSave = snapshot.data;
              //listen to state of the ui
              return StreamBuilder<UiState>(
                stream: _editDeliveryAddressBloc.uiState,
                builder: (context, snapshot) {
                  //ui state
                  final uiState = snapshot.data;

                  return CustomButton(
                    padding: AppPaddings.mediumButtonPadding(),
                    color: AppColor.primaryColor,
                    // disabledColor: Colors.white,
                    child: uiState != UiState.loading
                        ? Text(
                            GeneralStrings.update,
                            style: AppTextStyle.h4TitleTextStyle(
                              color: Colors.white,
                            ),
                          )
                        : PlatformCircularProgressIndicator(),
                    onPressed:
                        canSave != null && canSave && uiState != UiState.loading
                            ? _editDeliveryAddressBloc.saveDeliveryAddress
                            : null,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _pickNewDeliveryAddress() async {
    //add the newly selected delivery address to user account on the server
    _editDeliveryAddressBloc.showDeliveryAddressLocationPicker(context);
  }
}
