import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Doory/bloc/delivery_addresses.bloc.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_routes.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/data/models/deliver_address.dart';
import 'package:Doory/sample_data/delivery_addresses.dart';
import 'package:Doory/utils/custom_dialog.dart';
import 'package:Doory/widgets/buttons/custom_button.dart';
import 'package:Doory/widgets/delivery_address/delivery_address_item.dart';
import 'package:Doory/widgets/empty/empty_delivery_address.dart';
import 'package:Doory/widgets/shimmers/general_shimmer_list_view_item.dart';

class DeliverTo extends StatefulWidget {
  DeliverTo({
    Key key,
    this.onSubmit,
  }) : super(key: key);

  final Function(DeliveryAddress) onSubmit;

  @override
  _DeliverToState createState() => _DeliverToState();
}

class _DeliverToState extends State<DeliverTo> {
  //delivery locations
  List<DeliveryAddress> deliveryAddresses =
      DeliveryAddresses.deliveryAddresses();

  //delivery address bloc
  DeliveryAddressBloc _deliveryAddressBloc = DeliveryAddressBloc();

  @override
  void initState() {
    super.initState();
    _deliveryAddressBloc.initBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //make if fill 60% of the screen
      height: MediaQuery.of(context).size.height * 0.50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //manage delivery address
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //sort by section
              Expanded(
                child: Text(
                  "Deliver To",
                  style: AppTextStyle.h3TitleTextStyle(),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              //add delivery address
              CustomButton(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Icon(
                      AntDesign.plus,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "New",
                      style: AppTextStyle.h4TitleTextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                color: AppColor.accentColor,
                onPressed: _addNewDeliveryAddress,
              ),
            ],
          ),
          Divider(),
          //body
          // UiSpacer.verticalSpace(space: 20),
          Expanded(
            child: StreamBuilder<List<DeliveryAddress>>(
              stream: _deliveryAddressBloc.deliveryAddresses,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return EmptyDeliveryAddresses();
                } else if (!snapshot.hasData) {
                  return GeneralShimmerListViewItem();
                } else if (snapshot.data.length == 0) {
                  return EmptyDeliveryAddresses();
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    return DeliveryAddressItem(
                      deliveryAddress: snapshot.data[index],
                      onPressed: _onDeliveryAddressSelected,
                    );
                  },
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemCount: snapshot.data.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onDeliveryAddressSelected(DeliveryAddress selectedDeliveryAddres) {
    CustomDialog.dismissDialog(context);
    widget.onSubmit(selectedDeliveryAddres);
  }

  void _addNewDeliveryAddress() async {
    //add the newly selected delivery address to user account on the server
    CustomDialog.dismissDialog(context);
    Navigator.pushNamed(
      context,
      AppRoutes.newDeliveryAddressRoute,
    );
  }
}
