part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}

final class HomeDataLoaded extends HomeState {
  final List<ProductModel> products;
  final List<CategoryModel> categories;

  HomeDataLoaded({required this.products, required this.categories});
}

// ==========================================
// Categories
// final class HomeCategoriesLoading extends HomeState {}

// final class HomeCategoriesError extends HomeState {
//   final String message;
//   HomeCategoriesError({required this.message});
// }

// final class HomeCategoriesLoaded extends HomeState {
//   final List<CategoryModel> categories;
//   HomeCategoriesLoaded({required this.categories});
// }

// final class HomeCategoryLoading extends HomeState {}

// final class HomeCategoryError extends HomeState {
//   final String message;
//   HomeCategoryError({required this.message});
// }

// final class HomeCategoryLoaded extends HomeState {
//   final CategoryModel category;
//   HomeCategoryLoaded({required this.category});
// }

// final class CategoryProductsLoading extends HomeState {}

// final class CategoryProductsError extends HomeState {
//   final String message;
//   CategoryProductsError({required this.message});
// }

// final class CategoryProductsLoaded extends HomeState {
//   final List<ProductModel> products;
//   CategoryProductsLoaded({required this.products});
// }

// ==========================================
// Products
final class HomeProductsLoading extends HomeState {}

final class HomeProductsError extends HomeState {
  final String message;
  HomeProductsError({required this.message});
}

final class HomeProductsLoaded extends HomeState {
  final FilteredProductsResponse productsResponse;
  HomeProductsLoaded({required this.productsResponse});
}

final class HomeProductLoading extends HomeState {}

final class HomeProductError extends HomeState {
  final String message;
  HomeProductError({required this.message});
}

final class HomeProductLoaded extends HomeState {
  final ProductModel product;
  HomeProductLoaded({required this.product});
}

final class FilterProductsSuccess extends HomeState {
  final FilteredProductsResponse product;

  FilterProductsSuccess({required this.product});
}

final class HomeFavoritesLoading extends HomeState {}

final class HomeFavoritesError extends HomeState {
  final String message;
  HomeFavoritesError({required this.message});
}

final class HomeFavoritesLoaded extends HomeState {}

final class AddToFavoritesLoading extends HomeState {}

final class ToggleFavouritesError extends HomeState {
  final String message;
  ToggleFavouritesError({required this.message});
}

final class ToggleFavouritesSuccess extends HomeState {
  final String message;
  ToggleFavouritesSuccess({required this.message});
}

// ratings
final class SubmitRatingLoading extends HomeState {}

final class SubmitRatingError extends HomeState {
  final String message;
  SubmitRatingError({required this.message});
}

final class SubmitRatingSuccess extends HomeState {
  final String message;
  SubmitRatingSuccess({required this.message});
}

final class RatingsLoading extends HomeState {}

final class RatingsError extends HomeState {
  final String message;
  RatingsError({required this.message});
}

final class RatingsLoaded extends HomeState {
  final List<RatingResponseModel> ratings;
  RatingsLoaded({required this.ratings});
}

final class UserRatingLoaded extends HomeState {
  final RatingResponseModel rating;
  UserRatingLoaded({required this.rating});
}

final class DeleteRatingSuccess extends HomeState {}

final class UserRatingError extends HomeState {
  final String message;
  UserRatingError({required this.message});
}

final class GetSummaryLoading extends HomeState {}

final class GetSummaryError extends HomeState {
  final String message;
  GetSummaryError({required this.message});
}

final class GetSummaryLoaded extends HomeState {
  final RatingSummaryModel summary;
  GetSummaryLoaded({required this.summary});
}

// Recommended Products
final class RecommendedProductsLoading extends HomeState {}
final class RecommendedProductsError extends HomeState {
  final String message;
  RecommendedProductsError({required this.message});
}
final class RecommendedProductsLoaded extends HomeState {
  final List<ProductModel> products;
  RecommendedProductsLoaded({required this.products});
}

// final class RemoveFromFavoritesLoading extends HomeState {}
// final class RemoveFromFavoritesError extends HomeState {
//   final String message;
//   RemoveFromFavoritesError({required this.message});
// }
