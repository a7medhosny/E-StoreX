import 'package:bloc/bloc.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/search/data/repo/search_repo.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;
  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  /// Initial state
  Future<void> getInitialState() async {
    emit(SearchInitial());
  }

  /// Search
  Future<void> searchProducts(String query) async {
    emit(HomeSearchLoading());
    try {
      final response = await searchRepo.getFilteredProducts({
        'searchBy': 'name',
        'searchString': query,
      });
      emit(HomeSearchResultsLoaded(products: response.data));
    } catch (e) {
      emit(HomeSearchError(message: extractMessage(e)));
    }
  }

  String extractMessage(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }
}
