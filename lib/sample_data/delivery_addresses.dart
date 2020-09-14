import 'package:foodie/data/models/deliver_address.dart';

class DeliveryAddresses {
  //all sample food options
  static List<DeliveryAddress> deliveryAddresses() {
    List<DeliveryAddress> deliveryAddresses = [];

    var mDeliveryAddress = DeliveryAddress(
      id: 1,
      name: "Grainfield Dr",
      address: "5910 Grainfield Dr, Sylvania, OH, 43560 ",
      type: "home",
    );
    deliveryAddresses.add(mDeliveryAddress);

    mDeliveryAddress = DeliveryAddress(
      id: 1,
      name: "Hillsboro",
      address: "213 N Washington St, Hillsboro, KS, 67063",
      type: "office",
    );
    deliveryAddresses.add(mDeliveryAddress);

    mDeliveryAddress = DeliveryAddress(
      id: 1,
      name: "Flour Creek",
      address: "3704 Flour Creek Rd, Butler, KY, 41006",
    );
    deliveryAddresses.add(mDeliveryAddress);

    mDeliveryAddress = DeliveryAddress(
      id: 1,
      name: "Rocky Mount",
      address: "3430 Goose Dam Rd, Rocky Mount, VA, 24151",
    );
    deliveryAddresses.add(mDeliveryAddress);

    mDeliveryAddress = DeliveryAddress(
      id: 1,
      name: "Massachusetts Ave",
      address: "650 Massachusetts Ave, Boxborough, MA, 01719 ",
    );
    deliveryAddresses.add(mDeliveryAddress);

    return deliveryAddresses;
  }
}
