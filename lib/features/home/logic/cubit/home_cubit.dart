import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/helpers/strings.dart';
import 'package:ecommerce/features/home/data/models/rating_request_model.dart';
import 'package:ecommerce/features/home/data/models/rating_response_model.dart';
import 'package:ecommerce/features/home/data/models/rating_summary_model.dart';
import 'package:meta/meta.dart';

import 'package:ecommerce/features/shop/categories/data/models/category_model.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/basket/data/models/basket_request_model.dart';
import 'package:ecommerce/features/home/data/models/filtered_products_response.dart';
import 'package:ecommerce/features/home/data/repos/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit({required this.homeRepo}) : super(HomeInitial());
  List<ProductModel> localProducts = [];
  List<ProductModel> favoriteProducts = [];
  List<CategoryModel> localCategories = [];
  List<RatingResponseModel> localRatings = [];

  /// Main home data (products + categories)
  Future<void> getAllHomeData() async {
    emit(HomeLoading());
    if (localCategories.isNotEmpty && localProducts.isNotEmpty) {
      print("Emit From Local");
      emit(
        HomeDataLoaded(products: localProducts, categories: localCategories),
      );
      return;
    }

    try {
      final response = await homeRepo.getAllHomeData();
      localProducts = response['products'] as List<ProductModel>;
      localCategories = response['categories'] as List<CategoryModel>;
            print("Emit From Request");

      emit(
        HomeDataLoaded(products: localProducts, categories: localCategories),
      );
    } catch (e) {
      emit(HomeError(message: extractMessage(e)));
    }
  }

  /// Products
  Future<void> getFilteredProducts({
    Map<String, dynamic> filters = const {},
  }) async {
    emit(HomeProductsLoading());
    try {
      final response = await homeRepo.getFilteredProducts(filters);
      emit(HomeProductsLoaded(productsResponse: response));
    } catch (e) {
      emit(HomeProductsError(message: extractMessage(e)));
    }
  }

  Future<void> getProductById(String id) async {
    emit(HomeProductLoading());
    try {
      final product = await homeRepo.getProductById(id);
      emit(HomeProductLoaded(product: product));
    } catch (e) {
      emit(HomeProductError(message: extractMessage(e)));
    }
  }

  Future<void> getFavorites() async {
    emit(HomeFavoritesLoading());
    try {
      final products = await homeRepo.getFavorites();
      favoriteProducts = products;
      emit(HomeFavoritesLoaded());
    } catch (e) {
      print('Error fetching favorites: $e');
      emit(HomeFavoritesError(message: extractMessage(e)));
    }
  }

  bool isFavorite(String productId) {
    try {
      return favoriteProducts.any((product) => product.id == productId);
    } catch (e) {
      emit(HomeFavoritesError(message: extractMessage(e)));
      return false;
    }
  }

  Future<void> toggleFavorite(ProductModel product) async {
    emit(AddToFavoritesLoading());
    try {
      if (!isFavorite(product.id!)) {
        await homeRepo.addToFavorites(product.id!);
        favoriteProducts.add(product);
        emit(ToggleFavouritesSuccess(message: 'Product added to favorites'));
      } else {
        await homeRepo.removeFromFavorites(product.id!);
        favoriteProducts.removeWhere((p) => p.id == product.id);
        emit(
          ToggleFavouritesSuccess(message: 'Product removed from favorites'),
        );
      }
    } catch (e) {
      emit(ToggleFavouritesError(message: extractMessage(e)));
    }
  }

  Future<void> getRecommendedProducts({required String categoryName}) async {
    emit(RecommendedProductsLoading());
    try {
      final products = await homeRepo
          .getFilteredProducts({
            "SearchBy": "category",
            "SearchString": categoryName,
          })
          .then((r) => r.data);
      emit(RecommendedProductsLoaded(products: products));
    } catch (e) {
      emit(RecommendedProductsError(message: extractMessage(e)));
    }
  }

  /// Ratings
  Future<void> getRatingsByProductId(String productId) async {
    emit(RatingsLoading());
    try {
      final ratings = await homeRepo.getRatingsByProductId(productId);
      localRatings = ratings;
      emit(RatingsLoaded(ratings: ratings));
    } catch (e) {
      emit(RatingsError(message: extractMessage(e)));
    }
  }

  Future<void> getUserRating(String productId) async {
    emit(RatingsLoading());
    try {
      final rating = await homeRepo.getUserRating(productId);
      emit(UserRatingLoaded(rating: rating));
    } catch (e) {
      emit(UserRatingError(message: extractMessage(e)));
    }
  }

  Future<void> getRatingSummary(String productId) async {
    emit(GetSummaryLoading());
    try {
      final summary = await homeRepo.getRatingSummary(productId);
      emit(GetSummaryLoaded(summary: summary));
    } catch (e) {
      emit(GetSummaryError(message: extractMessage(e)));
    }
  }

  Future<void> submitRating({
    required int score,
    required String comment,
    required String productId,
  }) async {
    emit(SubmitRatingLoading());
    try {
      final rating = RatingRequestModel(
        score: score,
        comment: comment,
        productId: productId,
      );
      final userRating = await homeRepo.submitRating(rating);
      // emit(SubmitRatingSuccess(message: 'Rating submitted successfully'));
      localRatings.add(userRating);
      getUserRating(productId);
      getRatingSummary(productId);
      emit(RatingsLoaded(ratings: localRatings));
    } catch (e) {
      emit(SubmitRatingError(message: extractMessage(e)));
    }
  }

  Future<void> updateRating({
    required String id,
    required int score,
    required String comment,
    required String productId,
  }) async {
    emit(SubmitRatingLoading());
    try {
      final rating = RatingRequestModel(
        score: score,
        comment: comment,
        productId: productId,
      );
      final updatedRating = await homeRepo.updateRatingById(id, rating);
      // emit(SubmitRatingSuccess(message: 'Rating updated successfully'));
      final index = localRatings.indexWhere((r) => r.id == id);
      if (index != -1) {
        localRatings[index] = updatedRating;
      }
      getUserRating(productId);
      emit(RatingsLoaded(ratings: localRatings));
    } catch (e) {
      emit(SubmitRatingError(message: extractMessage(e)));
    }
  }

  Future<void> deleteRatingById({
    required String ratingId,
    required String productId,
  }) async {
    // emit(SubmitRatingLoading());
    try {
      await homeRepo.deleteRatingById(ratingId);
      localRatings.removeWhere((rating) => rating.id == ratingId);
      getRatingSummary(productId);
      emit(DeleteRatingSuccess());
      emit(RatingsLoaded(ratings: localRatings));
    } catch (e) {
      // emit(SubmitRatingError(message: extractMessage(e)));
    }
  }

  /// Helper
  String extractMessage(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }
}
