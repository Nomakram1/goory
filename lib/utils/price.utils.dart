class PriceUtils {
  static String intoDecimalPlaces(
    dynamic value, {
    int decimalPlaces = 2,
  }) {
    //convert to string then to double
    // final formattedValue = double.parse(value.toString());
    return value.toStringAsFixed(decimalPlaces);
  }
}
