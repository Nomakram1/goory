import 'package:Doory/bloc/base.bloc.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/data/models/deliver_address.dart';
import 'package:Doory/data/models/dialog_data.dart';
import 'package:Doory/data/repositories/delivery_address.repository.dart';
import 'package:rxdart/rxdart.dart';

class DeliveryAddressBloc extends BaseBloc {
  //delivery address repository
  DeliveryAddressRepository _deliveryAddressRepository =
      DeliveryAddressRepository();

  //BehaviorSubjects
  BehaviorSubject<List<DeliveryAddress>> _deliveryAddresses =
      BehaviorSubject<List<DeliveryAddress>>();

  //BehaviorSubject stream getters
  Stream<List<DeliveryAddress>> get deliveryAddresses =>
      _deliveryAddresses.stream;

  @override
  void initBloc() {
    super.initBloc();
    fetchDeliveryAddresses();
  }

  @override
  void dispose() {
    super.dispose();
    _deliveryAddresses.close();
  }

  void fetchDeliveryAddresses() async {
    _deliveryAddresses.add(null);
    try {
      final mDeliveryAddresses =
          await _deliveryAddressRepository.myDeliveryAddresses();
      _deliveryAddresses.add(mDeliveryAddresses);
    } catch (error) {
      _deliveryAddresses.addError(error);
    }
  }

  //delete delivery addres and remove form list of delivery address
  void deleteDeleteAddress({DeliveryAddress deliveryAddress, int index}) async {
    setUiState(UiState.loading);

    _deliveryAddresses.value.removeAt(index);
    _deliveryAddresses.add(_deliveryAddresses.value);

    // await Future.delayed(Duration(seconds: 5));
    dialogData = await _deliveryAddressRepository.deleteDeliveryAddress(
      deliveryAddress: deliveryAddress,
    );

    setUiState(UiState.done);

    if (dialogData.dialogType == DialogType.success) {
      dialogData.backgroundColor = AppColor.successfulColor;
      setShowAlert(true);
    } else {
      dialogData.backgroundColor = AppColor.failedColor;
      //refresh the ui to state before delete request was made
      _deliveryAddresses.value.insert(index, deliveryAddress);
      _deliveryAddresses.add(_deliveryAddresses.value);
      setShowAlert(true);
    }
  }
}
