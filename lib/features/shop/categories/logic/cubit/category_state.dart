part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}
final class HomeCategoriesLoading extends CategoryState {}

final class HomeCategoriesError extends CategoryState {
  final String message;
  HomeCategoriesError({required this.message});
}

final class HomeCategoriesLoaded extends CategoryState {
  final List<CategoryModel> categories;
  HomeCategoriesLoaded({required this.categories});
}

final class HomeCategoryLoading extends CategoryState {}

final class HomeCategoryError extends CategoryState {
  final String message;
  HomeCategoryError({required this.message});
}

final class HomeCategoryLoaded extends CategoryState {
  final CategoryModel category;
  HomeCategoryLoaded({required this.category});
}

final class CategoryProductLoading extends CategoryState {}

final class CategoryProductError extends CategoryState {
  final String message;
  CategoryProductError({required this.message});
}

final class CategoryProductLoaded extends CategoryState {
  final FilteredProductsResponse product;
  CategoryProductLoaded({required this.product});
}