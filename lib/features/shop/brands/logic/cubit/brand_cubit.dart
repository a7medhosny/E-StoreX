import 'package:bloc/bloc.dart';
import 'package:ecommerce/features/shop/brands/data/model/brand_response_model.dart';
import 'package:ecommerce/features/shop/brands/data/repo/brand_repo.dart';
import 'package:ecommerce/features/home/data/models/filtered_products_response.dart';
import 'package:meta/meta.dart';

part 'brand_state.dart';

class BrandCubit extends Cubit<BrandState> {
  BrandCubit({required this.brandRepo}) : super(BrandInitial());
  final BrandRepo brandRepo;
  Future<void> getAllBrands() async {
    emit(BrandLoading());
    try {
      final brands = await brandRepo.getAllBrands();
      emit(BrandLoaded(brands: brands));
    } catch (e) {
      emit(BrandError(message: e.toString()));
    }
  }

  Future<void> getProductsByBrandName({
    required String brandName,
    required int pageNumber,
    required int pageSize,
  }) async {
    emit(BrandProductsLoading());
    try {
      final FilteredProductsResponse brandProducts = await brandRepo
          .getProductsByBrandName(brandName, pageNumber, pageSize);
      emit(BrandProductsLoaded(brandProducts: brandProducts));
    } catch (e) {
      emit(BrandProductsError(message: e.toString()));
    }
  }
}
