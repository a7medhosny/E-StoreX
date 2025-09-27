part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}
// ==========================================
// Search
final class HomeSearchLoading extends SearchState {}

final class HomeSearchError extends SearchState {
  final String message;
  HomeSearchError({required this.message});
}

final class HomeSearchResultsLoaded extends SearchState {
  final List<ProductModel> products;
  HomeSearchResultsLoaded({required this.products});
}