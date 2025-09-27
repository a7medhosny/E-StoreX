part of 'brand_cubit.dart';

@immutable
sealed class BrandState {}

final class BrandInitial extends BrandState {}

final class BrandLoading extends BrandState {}

final class BrandLoaded extends BrandState {
  final List<BrandResponseModel> brands;
  BrandLoaded({required this.brands});
}

final class BrandError extends BrandState {
  final String message;
  BrandError({required this.message});
}

final class BrandProductsLoading extends BrandState {}
final class BrandProductsLoaded extends BrandState {
  final FilteredProductsResponse brandProducts;
  BrandProductsLoaded({required this.brandProducts});
}
final class BrandProductsError extends BrandState {
  final String message;
  BrandProductsError({required this.message});
}
