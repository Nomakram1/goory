import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Doory/bloc/base.bloc.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_images.dart';
import 'package:Doory/constants/app_routes.dart';
import 'package:Doory/constants/app_strings.dart';
import 'package:Doory/constants/strings/checkout.strings.dart';
import 'package:Doory/constants/strings/profile/delivery_address.strings.dart';
import 'package:Doory/data/models/deliver_address.dart';
import 'package:Doory/data/models/dialog_data.dart';
import 'package:Doory/data/models/product.dart';
import 'package:Doory/data/models/payment_option.dart';
import 'package:Doory/data/repositories/checkout.repository.dart';
import 'package:paystack_manager/paystack_manager.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rxdart/rxdart.dart';

class CheckOutBloc extends BaseBloc {
  //Razorpay instance
  final _razorpay = Razorpay();

  //delivery address repository
  CheckOutRepository _checkOutRepository = CheckOutRepository();

  //
  var cartTotalAmount = 0.00;
  var cartSubTotalAmount = 0.00;
  var vendorDeliveryFee = 0.00;

  //BehaviorSubjects
  BehaviorSubject<DeliveryAddress> _selectedDeliveryAddress =
      BehaviorSubject<DeliveryAddress>();
  BehaviorSubject<List<PaymentOption>> _paymentOptions =
      BehaviorSubject<List<PaymentOption>>();

  //BehaviorSubject stream getters
  Stream<DeliveryAddress> get selectedDeliveryAddress =>
      _selectedDeliveryAddress.stream;
  Stream<List<PaymentOption>> get paymentOptions => _paymentOptions.stream;

  @override
  void initBloc() async {
    super.initBloc();
    fetchPaymentOptions();

    //fetch local data needed
    vendorDeliveryFee =
        (await appDatabase.vendorDao.findAllVendors())[0].deliveryFee;
    (await appDatabase.productDao.findAllProducts()).forEach((product) {
      cartSubTotalAmount += product.priceWithExtras;
    });
    cartTotalAmount = cartSubTotalAmount + vendorDeliveryFee;
  }

  @override
  void dispose() {
    super.dispose();
    _selectedDeliveryAddress.close();
  }

  //geting the available payment methods/options
  void fetchPaymentOptions() async {
    _paymentOptions.add(null);
    try {
      final mPaymentOptions = await _checkOutRepository.paymentOptions();
      _paymentOptions.add(mPaymentOptions);
    } catch (error) {
      _paymentOptions.addError(error);
    }
  }

  //on user change delivery address
  void changeSelectedDeliveryAddres(DeliveryAddress selectedDeliveryAddres) {
    _selectedDeliveryAddress.add(selectedDeliveryAddres);
  }

  //when a payment option is selected
  void processCheckout(
    PaymentOption selectedPaymentOption,
    BuildContext context,
  ) async {
    //checking if user has selected a delivery address
    if (!_selectedDeliveryAddress.hasValue) {
      dialogData.title = DeliveryaAddressStrings.subTitle;
      dialogData.body = DeliveryaAddressStrings.selectionRequired;
      dialogData.backgroundColor = AppColor.failedColor;
      dialogData.iconData = FlutterIcons.error_mdi;
      setShowAlert(true);
    }
    //process the initiate checkout order
    else {
      //process the checkout
      dialogData.title = CheckoutStrings.title;
      dialogData.body = CheckoutStrings.processTitle;
      dialogData.dialogType = DialogType.loading;
      dialogData.isDismissible = false;

      //preparing data to be sent to server

      setShowDialogAlert(true);

      dialogData = await _checkOutRepository.initiateCheckout(
        paymentOption: selectedPaymentOption,
        deliveryAddress: _selectedDeliveryAddress.value,
        vendor: (await appDatabase.vendorDao.findAllVendors())[0],
        currency: (await appDatabase.currencyDao.findAllCurrencys())[0],
        totalAmount: cartTotalAmount,
        subTotalAmount: cartSubTotalAmount,
        deliveryFee: vendorDeliveryFee,
        products: await _fetchCartProductsAndExtras(),
      );

      setShowDialogAlert(false);
      //if request was successful then remove all item related to cart in the database
      if (dialogData.dialogType == DialogType.success) {
        //remove all item related to cart in the database
        await appDatabase.productDao
            .deleteItems(await appDatabase.productDao.findAllProducts());
        await appDatabase.vendorDao
            .deleteItems(await appDatabase.vendorDao.findAllVendors());
        await appDatabase.productExtraDao
            .deleteItems(await appDatabase.productExtraDao.findAll());
      }

      //check if we need to redirect user to payment platform
      if (dialogData.dialogType == DialogType.success &&
          selectedPaymentOption.isCard) {
        //show the page can dismiss itself
        // setShowDialogAlert(false);
        _processCardPayment(
          paymentOption: selectedPaymentOption,
          context: context,
          responseBody: dialogData.extraData,
        );
      } else {
        dialogData.isDismissible = true;
        dialogData.dialogType = DialogType.successThenClosePage;
        //notify the ui with the newly gotten dialogdata model
        setShowDialogAlert(true);
      }
    }
  }

  //fetch foods and food extras from database
  Future<List<Map<String, dynamic>>> _fetchCartProductsAndExtras() async {
    List<Map<String, dynamic>> productsWithExtras = [];

    //fetch currency in use
    final currency = (await appDatabase.currencyDao.findAllCurrencys())[0];
    //fetch all food from database
    List<Product> products = await appDatabase.productDao.findAllProducts();
    for (var product in products) {
      //the food extra with be converted to a sentance
      var extrasString = "";
      //get all food extras attached to this food
      final extras =
          await appDatabase.productExtraDao.findAllByProductId(product.id);
      extras.asMap().forEach((index, extra) {
        extrasString += "${extra.name}(${currency.symbol}${extra.price})";
        if (index < extras.length - 1) {
          extrasString += ",";
        }
      });

      productsWithExtras.add({
        "id": product.id,
        "price": product.priceWithExtras,
        "quantity": product.selectedQuantity,
        "extras": extrasString,
      });
    }

    return productsWithExtras;
  }

  //Payment via card
  void _processCardPayment({
    PaymentOption paymentOption,
    BuildContext context,
    dynamic responseBody,
  }) async {
    // print("Payment Option Name ==> ${paymentOption.name}");
    // print("Payment Option Slug ==> ${paymentOption.slug}");
    if (paymentOption.slug.toLowerCase() == "razorpay") {
      _payViaRazorPay(paymentOption, context);
    } else if (paymentOption.slug.toLowerCase() == "paystack") {
      _payViaPaystack(paymentOption, context);
    }
    //load the payment link
    else if (responseBody["link"] != null) {
      //
      Navigator.popAndPushNamed(
        context,
        AppRoutes.webViewRoute,
        arguments: responseBody["link"],
      );
    } else {
      print("Payment Payment not implmented");
    }
  }

  //razorpay payment
  void _payViaRazorPay(PaymentOption paymentOption, context) async {
    //add the razorpay handlers
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    var options = {
      'key': "${paymentOption.secretKey}",
      'amount': cartTotalAmount,
      'name': AppStrings.appName,
      'description': 'Payment for items in cart',
      'prefill': {
        'email': (await appDatabase.userDao.findCurrent()).email,
      }
    };

    //open the checkout
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("Payment Success Response ==> $response");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Payment failed Response ==> $response");
    print("Payment failed Response ==> ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print("Payment External Response ==> $response");
  }

  //paystack payment
  void _payViaPaystack(
      PaymentOption paymentOption, BuildContext context) async {
    final currentUser = await appDatabase.userDao.findCurrent();
    PaystackPayManager(context: context)
      ..setSecretKey(paymentOption.secretKey)
      //accepts widget
      ..setCompanyAssetImage(Image(
        image: AssetImage(AppImages.appLogo),
      ))
      ..setAmount(cartTotalAmount)
      ..setCurrency(
        (await appDatabase.currencyDao.findAllCurrencys())[0].code,
      )
      ..setEmail(currentUser.email)
      ..setFirstName(currentUser.name)
      ..setLastName("")
      ..setMetadata(
        {
          "custom_fields": [
            {
              "value": AppStrings.appName,
              "display_name": "Payment to",
              "variable_name": "payment_to"
            }
          ]
        },
      )
      ..onSuccesful(_onPaymentSuccessful)
      ..onFailed(_onPaymentFailed)
      ..onCancel(_onPaymentCancelled)
      ..initialize();
  }

  void _onPaymentSuccessful(Transaction transaction) {
    print("Transaction was successful");
    print("Transaction Message ===> ${transaction.message}");
    print("Transaction Refrence ===> ${transaction.refrenceNumber}");
  }

  void _onPaymentFailed(Transaction transaction) {
    print("Transaction failed");
  }

  void _onPaymentCancelled(Transaction transaction) {
    print("Transaction was cancelled");
  }
}
