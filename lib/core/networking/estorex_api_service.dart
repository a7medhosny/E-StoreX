import 'dart:io';

import 'package:ecommerce/features/auth/login/data/models/auth_response_model.dart';
import 'package:ecommerce/features/auth/login/data/models/login_request_model.dart';
import 'package:ecommerce/features/auth/models/forgot_password_request.dart';
import 'package:ecommerce/features/auth/models/refresh_token_request.dart';
import 'package:ecommerce/features/auth/models/reset_password_request.dart';
import 'package:ecommerce/features/auth/register/data/models/register_request_model.dart';
import 'package:ecommerce/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/features/basket/data/models/basket_response_model.dart';
import 'package:ecommerce/features/shop/brands/data/model/brand_response_model.dart';
import 'package:ecommerce/features/home/data/models/filtered_products_response.dart';
import 'package:ecommerce/features/home/data/models/rating_request_model.dart';
import 'package:ecommerce/features/home/data/models/rating_response_model.dart';
import 'package:ecommerce/features/home/data/models/rating_summary_model.dart';
import 'package:ecommerce/features/order/data/models/delivery_option.dart';
import 'package:ecommerce/features/order/data/models/order_request_model.dart';
import 'package:ecommerce/features/order/data/models/order_response_model.dart';
import 'package:ecommerce/features/order/data/models/payment_response.dart';
import 'package:ecommerce/features/profile/data/models/profile_response_model.dart';
import 'package:ecommerce/features/profile/data/models/update_profile_request.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/shop/categories/data/models/category_model.dart';
import '../../features/home/data/models/product_model.dart';
import '../../features/basket/data/models/basket_request_model.dart';

part 'estorex_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class EStoreXApiService {
  factory EStoreXApiService(Dio dio, {String baseUrl}) = _EStoreXApiService;

  // Categories
  @GET(ApiConstants.categories)
  Future<List<CategoryModel>> getAllCategories();

  @GET("${ApiConstants.categories}/{id}")
  Future<CategoryModel> getCategoryById(@Path("id") String id);

  @POST(ApiConstants.categories)
  Future<void> createNewCategory(@Body() Map<String, dynamic> category);

  @PUT("${ApiConstants.categories}/{id}")
  Future<void> updateCategoryById(
    @Path("id") String id,
    @Body() Map<String, dynamic> category,
  );

  @DELETE("${ApiConstants.categories}/{id}")
  Future<void> deleteCategoryById(@Path("id") String id);

  // Products
  @GET(ApiConstants.products)
  Future<FilteredProductsResponse> getFilteredProducts(
    @Queries() Map<String, dynamic> filters,
  );

  @GET("${ApiConstants.products}/{id}")
  Future<ProductModel> getProductById(@Path("id") String id);

  @MultiPart()
  @POST(ApiConstants.products)
  Future<ProductModel> createProductWithImages(
    @Part(name: "name") String name,
    @Part(name: "description") String description,
    @Part(name: "newPrice") double newPrice,
    @Part(name: "oldPrice") double oldPrice,
    @Part(name: "categoryId") String categoryId,
    @Part(name: "photos") List<MultipartFile> photos,
    @Part(name: "quantityAvailable") int quantityAvailable,
    @Part(name: "brandName") String brandName,
  );

  @MultiPart()
  @PUT("${ApiConstants.products}/{id}")
  Future<void> updateProductWithImagesById(
    @Path("id") String id,
    @Part(name: "name") String name,
    @Part(name: "description") String description,
    @Part(name: "newPrice") double newPrice,
    @Part(name: "oldPrice") double oldPrice,
    @Part(name: "categoryId") String categoryId,
    @Part(name: "photos") List<MultipartFile> photos,
  );

  @DELETE("${ApiConstants.products}/{basketId}")
  Future<void> deleteProductById(@Path("basketId") String basketId);

  // Baskets
  @GET("${ApiConstants.baskets}/{basketId}")
  Future<BasketResponseModel?> getBasketByCustomerId(
    @Path("basketId") String basketId,
  );

  @POST(ApiConstants.baskets)
  Future<void> addOrUpdateCustomerBasket(@Body() BasketRequestModel basket);

  @DELETE("${ApiConstants.baskets}/{basketId}")
  Future<void> deleteBasketByCustomerId(@Path("basketId") String basketId);

  @DELETE("${ApiConstants.baskets}/{basketId}/items/{productId}")
  Future<void> deleteItemFromBasketByProductId(
    @Path("basketId") String basketId,
    @Path("productId") String productId,
  );

  ///api/v1/Baskets/{basketId}/items/{productId}
  @PATCH("${ApiConstants.baskets}/{basketId}/items/{productId}/increase")
  Future<BasketResponseModel> increaseBasketItem(
    @Path("basketId") String basketId,
    @Path("productId") String productId,
  );

  @PATCH("${ApiConstants.baskets}/{basketId}/items/{productId}/decrease")
  Future<BasketResponseModel> decreaseBasketItem(
    @Path("basketId") String basketId,
    @Path("productId") String productId,
  );

  @POST("${ApiConstants.baskets}/{basketId}/apply-discount/{code}")
  Future<BasketResponseModel> applyDiscount(
    @Path("basketId") String basketId,
    @Path("code") String code,
  );

  @POST(ApiConstants.mergeBasket)
  Future<BasketResponseModel> mergeBasketWithGuestBasket(
    @Query('guestId') String guestId,
  );

  // Auth
  @POST(ApiConstants.register)
  Future<AuthResponseModel> registerUser(
    @Body() RegisterRequestModel registerModel,
  );

  @POST(ApiConstants.login)
  Future<AuthResponseModel> loginUser(@Body() LoginRequestModel loginModel);

  @POST(ApiConstants.forgotPassword)
  Future<AuthResponseModel> forgotPassword(
    @Body() ForgotPasswordRequest request,
  );

  @POST(ApiConstants.resetPassword)
  Future<AuthResponseModel> resetPassword(@Body() ResetPasswordRequest request);

  @POST(ApiConstants.refreshToken)
  Future<AuthResponseModel> refreshToken(@Body() RefreshTokenRequest request);

  @GET(ApiConstants.externalLogin)
  Future<AuthResponseModel> externalLogin(@Query('provider') String provider);

  @GET(ApiConstants.logout)
  Future<AuthResponseModel> logout();

  @DELETE(ApiConstants.deleteAccount)
  Future<AuthResponseModel> deleteAccount();

  //Orders
  @GET(ApiConstants.deliveryMethods)
  Future<List<DeliveryOption>> getDeliveryMethods();

  @POST(ApiConstants.orders)
  Future<OrderResponseModel> createOrder(@Body() OrderRequestModel order);

  @GET(ApiConstants.orders)
  Future<List<OrderResponseModel>> getOrders();

  @GET("${ApiConstants.orders}/{orderId}")
  Future<OrderResponseModel> getOrderById(@Path("orderId") String id);

  @POST(ApiConstants.payment)
  Future<PaymentResponse> getPaymentIntentData(
    @Query('basketId') String basketId,
    @Query('deliveryMethodId') String deliveryMethodId,
  );

  //favorites
  @GET(ApiConstants.favourites)
  Future<List<ProductModel>> getFavorites();

  @POST("${ApiConstants.favourites}/{id}")
  Future<void> addToFavorites(@Path("id") String id);

  @DELETE("${ApiConstants.favourites}/{id}")
  Future<void> removeFromFavorites(@Path("id") String id);

  // Ratings
  @GET("${ApiConstants.ratingsByProduct}/{productId}")
  Future<List<RatingResponseModel>> getRatingsByProductId(
    @Path("productId") String productId,
  );

  @GET("${ApiConstants.ratingsByProduct}/{productId}/my-rating")
  Future<RatingResponseModel> getUserRating(
    @Path("productId") String productId,
  );
  @GET("${ApiConstants.ratingsByProduct}/{productId}/summary")
  Future<RatingSummaryModel> getRatingSummary(
    @Path("productId") String productId,
  );

  @POST(ApiConstants.ratings)
  Future<RatingResponseModel> submitRating(@Body() RatingRequestModel rating);

  @PUT("${ApiConstants.ratings}/{id}")
  Future<RatingResponseModel> updateRatingById(
    @Path("id") String id,
    @Body() RatingRequestModel rating,
  );

  @DELETE("${ApiConstants.ratings}/{id}")
  Future<void> deleteRatingById(@Path("id") String id);

  // Profile
  @GET(ApiConstants.profile)
  Future<ProfileResponseModel> getUserProfile();

  @PATCH(ApiConstants.updateProfile)
  Future<AuthResponseModel> updateUserProfile(
    @Body() UpdateProfileRequest updatedProfileRequest,
  );

  @PATCH(ApiConstants.uploadPhoto)
  @MultiPart()
  Future<AuthResponseModel> uploadUserPhoto(@Part(name: "file") File file);

  // Discounts
  @GET("${ApiConstants.validateDiscount}/{code}")
  Future<AuthResponseModel> validateDiscount(@Path("code") String code);

  //Brands
  @GET(ApiConstants.brands)
  Future<List<BrandResponseModel>> getAllBrands();
}
