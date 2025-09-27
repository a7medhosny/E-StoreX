class ApiConstants {
  static const String baseUrl = 'https://estorex.runasp.net/api/v1';

  // Endpoints
  static const String categories = '/categories';
  static const String products = '/products';
  static const String baskets = '/Baskets';

  static const String mergeBasket = '/baskets/merge';

  // Bugs (for testing errors)
  static const String error = '/bug/error';
  static const String notFound = '/bug/not-found';
  static const String badRequest = '/bug/bad-request';

  // Auth
  static const String register = '/account/register';
  static const String login = '/Account/login';
  static const String resetPassword = '/account/reset-password';
  static const String refreshToken = '/account/refresh-token';
  static const String forgotPassword = '/account/forgot-password';
  static const String externalLogin = '/account/external-login';
  static const String logout = '/account/logout';
  static const String deleteAccount = '/account/delete';

  // orders
  static const String deliveryMethods = "/Orders/delivery-methods";
  static const String payment = "/Payments";
  static const String orders = "/Orders";

  // favourites
  static const String favourites = '/favourites';

  // Ratings
  static const String ratings = '/ratings';
  static const String ratingsByProduct = '/ratings/product';

  // Profie
  static const String profile = '/account/me';
  static const String updateProfile = '/account/update-profile';
  static const String uploadPhoto = '/account/upload-photo';

  //Discounts
  static const String validateDiscount = '/Discounts/validate';

  // Brands

  static const String brands = '/brands';
}
