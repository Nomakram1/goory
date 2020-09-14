import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

@Entity(
  tableName: "currencies",
)
class Currency {
  @primaryKey
  int id;
  String name;
  String code;
  String symbol;

  Currency({
    this.id,
    this.name,
    this.code,
    this.symbol,
  });

  //format from json/map to object
  factory Currency.fromJson({
    @required dynamic currencyJSONObject,
  }) {
    final currency = Currency();
    currency.id = currencyJSONObject["id"];
    currency.name = currencyJSONObject["name"];
    currency.code = currencyJSONObject["code"];
    currency.symbol = currencyJSONObject["symbol"];
    return currency;
  }
}
