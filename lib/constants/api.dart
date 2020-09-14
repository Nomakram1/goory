class Api {
  // static const baseUrl = "http://192.168.8.145:8000/api";
  // static const baseUrl = "http://192.168.43.32:8000/api";
  static const baseUrl = "https://food.thesnaptask.com/api";

  static const login = "/login";
  static const loginSocial = "/login/social";
  static const register = "/register";
  static const logout = "/logout";
  static const forgotPassword = "/password/reset/init";

  static const changePassword = "/password/change";
  static const updateProfile = "/user/update";

  static const categories = "/categories";
  static const vendors = "/vendors";
  static const deliveryAddress = "/delivery/addresses";

  static const paymentOptions = "/payment/options";

  static const initiateCheckout = "/checkout/initiate";
  static const finalizecheckout = "/checkout/finalize";

  static const orders = "/orders";
}
