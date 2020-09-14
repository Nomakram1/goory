import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/strings/general.strings.dart';
import 'package:foodie/constants/strings/product.strings.dart';
import 'package:foodie/data/database/app_database_singleton.dart';
import 'package:foodie/data/models/product.dart';
import 'package:foodie/data/models/food_extra.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/utils/price.utils.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BaseBloc {
  //selected food and vendor model
  Product selectedProduct;
  Vendor selectedVendor;

  //BehaviorSubjects
  BehaviorSubject<int> _selectedFoodQuantity = BehaviorSubject<int>.seeded(1);
  BehaviorSubject<String> _totalFoodAmount =
      BehaviorSubject<String>.seeded("0");

  //BehaviorSubject stream getters
  Stream<int> get selectedFoodQuantity => _selectedFoodQuantity.stream;
  Stream<String> get totalFoodAmount => _totalFoodAmount.stream;

  List<ProductExtra> _selectedProductExtras = [];
  @override
  void initBloc() {
    super.initBloc();
    _updateTotalFoodAmount();
  }

  void updateSelectedFoodExtras(
    ProductExtra selectedProductExtra,
    bool selected,
  ) {
    if (selected) {
      _selectedProductExtras.add(selectedProductExtra);
    } else {
      _selectedProductExtras.removeWhere(
        (productExtra) => productExtra.id == selectedProductExtra.id,
      );
    }

    _updateTotalFoodAmount();
  }

  void increaseFoodQuantity() {
    final newQty = _selectedFoodQuantity.value + 1;
    _selectedFoodQuantity.add(newQty);
    _updateTotalFoodAmount();
  }

  void decreaseFoodQuantity() {
    final newQty = _selectedFoodQuantity.value - 1;
    if (newQty >= 1) {
      _selectedFoodQuantity.add(newQty);
      _updateTotalFoodAmount();
    }
  }

  //method to update the total amount
  void _updateTotalFoodAmount() {
    //get the food total price first before calculating extras
    final selectedQty = _selectedFoodQuantity.value;
    final subTotalFoodPrice = selectedProduct.price * selectedQty;
    var selectedFoodExtrasPrice = 0.0;
    //calculate all the prices from selected food extras
    _selectedProductExtras.forEach((foodExtra) {
      selectedFoodExtrasPrice += foodExtra.price * selectedQty;
    });

    final totalFoodPrice = subTotalFoodPrice + selectedFoodExtrasPrice;
    final formattedTotalPrice = PriceUtils.intoDecimalPlaces(totalFoodPrice);
    _totalFoodAmount.add(formattedTotalPrice);
  }

  void addToCart({bool override = false}) async {
    //update food selected quantity
    selectedProduct.selectedQuantity = _selectedFoodQuantity.value;
    selectedProduct.priceWithExtras = double.parse(_totalFoodAmount.value);

    //saving the food and options to database
    //if food with same id has been saved before, it will update the record instead of creat new one
    final database = AppDatabaseSingleton.database;
    final foodsFound = await database.productDao.findAllByVendorWhereNot(
      selectedProduct.vendorId,
    );
    //first check if user selcted food from same vendor as any item already in the cart
    if (foodsFound.length > 0 && !override) {
      //prepare the data model to be used to show the alert on the view
      dialogData.title = ProductStrings.changeVendorTitle;
      dialogData.body = ProductStrings.changeVendorBody;
      dialogData.negativeButtonTitle = GeneralStrings.cancel;
      dialogData.positiveButtonTitle = GeneralStrings.yesClear;
      //show success alert
      setShowDialogAlert(true);
      return;
    } else if (override) {
      await database.productDao.deleteAllByVendorWhereNot(
        selectedProduct.vendorId,
      );
    }

    //save the vendor entity
    database.vendorDao.insertItem(selectedVendor);
    //save the food entity
    database.productDao.insertItem(selectedProduct);
    //delete all added food extras link to this food
    database.productExtraDao.deleteAllByProductId(selectedProduct.id);
    //save the food options entity
    database.productExtraDao.insertItems(_selectedProductExtras);

    //prepare the data model to be used to show the alert on the view
    dialogData.title = ProductStrings.addedToCart;
    dialogData.body =
        '${selectedProduct.name} ${ProductStrings.addedToCartMessage}';
    dialogData.backgroundColor = AppColor.successfulColor;
    dialogData.iconData = FlutterIcons.check_ant;
    //show success alert
    setShowAlert(true);
  }
}
