import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DeliveryAddress {
  int id;
  String name;
  String type;
  String address;
  String latitude;
  String longitude;

  DeliveryAddress({
    this.id,
    this.name,
    this.type = "",
    this.address,
    this.latitude,
    this.longitude,
  });

  Icon get icon {
    var iconData = FlutterIcons.location_arrow_faw;
    //change the icon base on the type of delivery address
    if (this.name.toLowerCase() == "home") {
      iconData = FlutterIcons.home_ant;
    } else if (this.name.toLowerCase() == "office") {
      iconData = FlutterIcons.office_building_mco;
    }

    return Icon(
      iconData,
      size: 18,
    );
  }

  factory DeliveryAddress.fromJSON({jsonObject}) {
    final deliveryAddress = DeliveryAddress();
    deliveryAddress.id = jsonObject["id"];
    deliveryAddress.name = jsonObject["name"] ?? "Location";
    deliveryAddress.address = jsonObject["address"];
    deliveryAddress.latitude = jsonObject["latitude"];
    deliveryAddress.longitude = jsonObject["longitude"];
    return deliveryAddress;
  }
}
