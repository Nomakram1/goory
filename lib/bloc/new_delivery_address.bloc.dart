import 'package:flutter/material.dart';
import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/constants/app_strings.dart';
import 'package:foodie/constants/validation_messages.dart';
import 'package:foodie/data/repositories/delivery_address.repository.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:rxdart/rxdart.dart';

class NewDeliveryAddressBloc extends BaseBloc {
  //delivery address repository
  DeliveryAddressRepository _deliveryAddressRepository =
      DeliveryAddressRepository();

  //TexteditingController for delivery address name
  TextEditingController deliveryAddressNameTEC = TextEditingController();

  //BehaviorSubjects
  BehaviorSubject<LocationResult> _selectedLocationResult =
      BehaviorSubject<LocationResult>();
  BehaviorSubject<bool> _validDeliveryAddressName = BehaviorSubject<bool>();

  //BehaviorSubject stream getters
  Stream<LocationResult> get selectedLocationResult =>
      _selectedLocationResult.stream;
  Stream<bool> get validDeliveryAddressName => _validDeliveryAddressName.stream;
  Stream<bool> get canSave => Rx.combineLatest2(
      _selectedLocationResult, _validDeliveryAddressName, (a, b) => true);

  @override
  void initBloc() {
    super.initBloc();
  }

  //as user enters delivery address name, we are doing name validation
  void validateDeliveryAddressName(String value) {
    if (value.isEmpty || value.length < 3) {
      _validDeliveryAddressName
          .addError(ValidationMessages.invalidDeliveryAddressName);
    } else {
      _validDeliveryAddressName.add(true);
    }
  }

  void showDeliveryAddressLocationPicker(
    BuildContext context,
  ) async {
    LocationResult locationResult = await showLocationPicker(
      context,
      AppStrings.googleApiKey,
      automaticallyAnimateToCurrentLocation: true,
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,
      // resultCardAlignment: Alignment.bottomCenter,
    );

    if (locationResult != null) {
      _selectedLocationResult.add(locationResult);
    } else {
      _selectedLocationResult.addError("Empty");
    }
  }

  //saving the delivery address
  void saveDeliveryAddress() async {
    //notify the view of the current state
    setUiState(UiState.loading);

    dialogData = await _deliveryAddressRepository.saveDeliveryAddress(
      name: deliveryAddressNameTEC.text,
      address: _selectedLocationResult.value.address,
      latitude: _selectedLocationResult.value.latLng.latitude,
      longitude: _selectedLocationResult.value.latLng.longitude,
    );
    //notify the view of the current state
    setUiState(UiState.done);
    setShowDialogAlert(true);
  }
}
