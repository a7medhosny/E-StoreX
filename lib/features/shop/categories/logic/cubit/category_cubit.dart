import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/features/shop/categories/data/repo/category_repo.dart';
import 'package:ecommerce/core/networking/estorex_api_service.dart';
import 'package:ecommerce/features/shop/categories/data/models/category_model.dart'
    show CategoryModel;
import 'package:ecommerce/features/home/data/models/filtered_products_response.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/data/repos/home_repo.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({required this.categoryRepo}) : super(CategoryInitial());
  final CategoryRepo categoryRepo;
  List<CategoryModel> localCategories = [];

  /// Categories
  Future<void> getAllCategories() async {
    emit(HomeCategoriesLoading());

    if (localCategories.isNotEmpty) {
      emit(HomeCategoriesLoaded(categories: localCategories));
      return;
    }
    try {
      final categories = await categoryRepo.getAllCategories();
      localCategories = categories;
      emit(HomeCategoriesLoaded(categories: categories));
    } catch (e) {
      emit(HomeCategoriesError(message: extractMessage(e)));
    }
  }

  Future<void> getCategoryById(String id) async {
    emit(HomeCategoryLoading());
    try {
      final category = await categoryRepo.getCategoryById(id);
      emit(HomeCategoryLoaded(category: category));
    } catch (e) {
      emit(HomeCategoryError(message: extractMessage(e)));
    }
  }

  Future<void> getProductByCategoryId({
    required String categoryName,
    required int pageNumber,
    required int pageSize,
  }) async {
    emit(CategoryProductLoading());
    try {
      final FilteredProductsResponse product = await categoryRepo.getFilteredProducts({
        'SearchString': categoryName,
        'SearchBy': 'category',
        'PageNumber': pageNumber,
        'PageSize': pageSize,
      });

      emit(CategoryProductLoaded(product: product));
    } catch (e) {
      emit(CategoryProductError(message: extractMessage(e)));
    }
  }

  String extractMessage(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }
}
