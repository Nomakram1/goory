import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodie/bloc/checkout.bloc.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/checkout.strings.dart';
import 'package:foodie/data/models/deliver_address.dart';
import 'package:foodie/data/models/payment_option.dart';
import 'package:foodie/utils/custom_dialog.dart';
import 'package:foodie/utils/ui_spacer.dart';
import 'package:foodie/widgets/appbar/leading_app_bar.dart';
import 'package:foodie/widgets/buttons/custom_button.dart';
import 'package:foodie/widgets/checkout/payment_option_list_view_item.dart';
import 'package:foodie/widgets/deliver_to_bottom_sheet_content.dart';
import 'package:foodie/widgets/delivery_address/delivery_address_item.dart';
import 'package:foodie/widgets/empty/empty_payment_method.dart';
import 'package:foodie/widgets/empty/no_selected_delivery_address.dart';
import 'package:foodie/widgets/list_view_header.dart';
import 'package:foodie/widgets/shimmers/general_shimmer_list_view_item.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  //DeliveryAddressBloc instance
  CheckOutBloc _checkOutBloc = CheckOutBloc();

  @override
  void initState() {
    super.initState();
    _checkOutBloc.initBloc();

    //listen to the need to show a dialog alert or a normal snackbar alert type
    _checkOutBloc.showAlert.listen((show) {
      //when asked to show an alert
      if (show) {
        EdgeAlert.show(
          context,
          title: _checkOutBloc.dialogData.title,
          description: _checkOutBloc.dialogData.body,
          backgroundColor: _checkOutBloc.dialogData.backgroundColor,
          icon: _checkOutBloc.dialogData.iconData,
        );
      }
    });

    //listen to the need to show a dialog alert type
    _checkOutBloc.showDialogAlert.listen(
      (show) {
        //when asked to show an alert
        if (show) {
          CustomDialog.showAlertDialog(
            context,
            _checkOutBloc.dialogData,
            isDismissible: _checkOutBloc.dialogData.isDismissible,
          );
        } else {
          CustomDialog.dismissDialog(context);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _checkOutBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        leading: LeadingAppBar(),
      ),
      body: ListView(
        padding: AppPaddings.defaultPadding(),
        children: <Widget>[
          //header
          Text(
            CheckoutStrings.title,
            style: AppTextStyle.h1TitleTextStyle(),
          ),

          //delivery addresses
          UiSpacer.verticalSpace(space: 30),
          Row(
            children: <Widget>[
              Flexible(
                child: ListViewHeader(
                  title: CheckoutStrings.deliverTo,
                  subTitle: CheckoutStrings.deliverToInstruction,
                  iconData: FlutterIcons.creditcard_ant,
                ),
              ),

              //change delivery address button
              ButtonTheme(
                height: 20,
                minWidth: 20,
                child: CustomButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  color: AppColor.primaryColor,
                  child: Text(
                    CheckoutStrings.changeAddress,
                    style: AppTextStyle.h5TitleTextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _changeDeliveryAddress,
                ),
              ),
            ],
          ),
          //selected delivery addresses
          UiSpacer.verticalSpace(space: 10),
          StreamBuilder<DeliveryAddress>(
            stream: _checkOutBloc.selectedDeliveryAddress,
            builder: (context, snapshot) {
              if (snapshot.hasError || !snapshot.hasData) {
                return NoSelectedDeliveryAddresses();
              }

              return Container(
                // padding: AppPaddings.defaultPadding(),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(0.10),
                  borderRadius: AppSizes.containerBorderRadiusShape(radius: 5),
                  // color: AppColor.primaryColor,
                ),
                child: DeliveryAddressItem(
                  deliveryAddress: snapshot.data,
                  onPressed: null,
                  onLongPressed: null,
                ),
              );
            },
          ),

          //payment options
          UiSpacer.verticalSpace(space: 10),
          Divider(
            thickness: 3,
          ),
          UiSpacer.verticalSpace(space: 10),
          ListViewHeader(
            title: CheckoutStrings.paymentOptions,
            subTitle: CheckoutStrings.paymentOptionsInstruction,
            iconData: FlutterIcons.creditcard_ant,
          ),
          UiSpacer.verticalSpace(space: 20),
          StreamBuilder<List<PaymentOption>>(
            stream: _checkOutBloc.paymentOptions,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return EmptyPaymentMethod();
              } else if (!snapshot.hasData) {
                return GeneralShimmerListViewItem();
              } else if (snapshot.data.length == 0) {
                return EmptyPaymentMethod();
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    UiSpacer.verticalSpace(space: 20),
                itemBuilder: (context, index) {
                  return PaymentOptionListViewItem(
                    paymentOption: snapshot.data[index],
                    onPressed: (PaymentOption paymentOption) {
                      _checkOutBloc.processCheckout(
                        paymentOption,
                        context,
                      );
                    },
                  );
                },
                itemCount: snapshot.data.length,
              );
            },
          ),
        ],
      ),
    );
  }

  void _changeDeliveryAddress() {
    //show bottomsheet with delivery addresses container
    CustomDialog.showCustomBottomSheet(
      context,
      contentPadding: EdgeInsets.all(20),
      content: DeliverTo(
        onSubmit: _checkOutBloc.changeSelectedDeliveryAddres,
      ),
    );
  }
}
