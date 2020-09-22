import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Doory/bloc/base.bloc.dart';
import 'package:Doory/bloc/delivery_addresses.bloc.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_routes.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/constants/strings/profile/delivery_address.strings.dart';
import 'package:Doory/data/models/deliver_address.dart';
import 'package:Doory/utils/ui_spacer.dart';
import 'package:Doory/widgets/appbar/leading_app_bar.dart';
import 'package:Doory/widgets/delivery_address/delivery_address_item.dart';
import 'package:Doory/widgets/empty/empty_delivery_address.dart';
import 'package:Doory/widgets/shimmers/general_shimmer_list_view_item.dart';

class DeliveryAddressesPage extends StatefulWidget {
  DeliveryAddressesPage({Key key}) : super(key: key);

  @override
  _DeliveryAddressesPageState createState() => _DeliveryAddressesPageState();
}

class _DeliveryAddressesPageState extends State<DeliveryAddressesPage> {
  //delivery address bloc
  DeliveryAddressBloc _deliveryAddressBloc = DeliveryAddressBloc();

  @override
  void initState() {
    super.initState();

    _deliveryAddressBloc.initBloc();
    //listen to the need to show a dialog alert or a normal snackbar alert type
    _deliveryAddressBloc.showAlert.listen((show) {
      //when asked to show an alert
      if (show) {
        EdgeAlert.show(
          context,
          title: _deliveryAddressBloc.dialogData.title,
          description: _deliveryAddressBloc.dialogData.body,
          backgroundColor: _deliveryAddressBloc.dialogData.backgroundColor,
          icon: _deliveryAddressBloc.dialogData.iconData,
        );
      }
    });
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.newDeliveryAddressRoute,
          );
        },
        child: Icon(AntDesign.plus),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          AppPaddings.contentPaddingSize,
          0,
          AppPaddings.contentPaddingSize,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //loading progress bar
            StreamBuilder<UiState>(
              stream: _deliveryAddressBloc.uiState,
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.data == UiState.loading
                    ? SizedBox(
                        child: LinearProgressIndicator(),
                        height: 3,
                      )
                    : SizedBox.shrink();
              },
            ),
            //header
            Text(
              DeliveryaAddressStrings.title,
              style: AppTextStyle.h1TitleTextStyle(),
            ),
            Text(
              DeliveryaAddressStrings.instruction,
              style: AppTextStyle.h5TitleTextStyle(),
            ),
            UiSpacer.verticalSpace(),

            //select delivery address info
            Expanded(
              child: StreamBuilder<List<DeliveryAddress>>(
                stream: _deliveryAddressBloc.deliveryAddresses,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return EmptyDeliveryAddresses();
                  } else if (!snapshot.hasData) {
                    return GeneralShimmerListViewItem();
                  } else if (snapshot.data.length == 0) {
                    return EmptyDeliveryAddresses(
                      scrollable: false,
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.only(
                      bottom: AppPaddings.contentPaddingSize * 5,
                    ),
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(snapshot.data[index].id.toString()),
                        background: Container(
                          color: Colors.red,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              UiSpacer.horizontalSpace(),
                              Icon(
                                AntDesign.delete,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                AntDesign.delete,
                                color: Colors.white,
                              ),
                              UiSpacer.horizontalSpace()
                            ],
                          ),
                        ),
                        child: DeliveryAddressItem(
                          deliveryAddress: snapshot.data[index],
                          onPressed: null,
                          onLongPressed: _editDeliveryAddress,
                        ),
                        onDismissed: (direction) {
                          _deliveryAddressBloc.deleteDeleteAddress(
                            deliveryAddress: snapshot.data[index],
                            index: index,
                          );
                        },
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
      ),
    );
  }

  void _editDeliveryAddress(DeliveryAddress deliveryAddress) async {
    //call the update page
    await Navigator.pushNamed(
      context,
      AppRoutes.editDeliveryAddressRoute,
      arguments: deliveryAddress,
    );

    //then refresh list incase user modify any delivery address
    _deliveryAddressBloc.fetchDeliveryAddresses();
  }
}
