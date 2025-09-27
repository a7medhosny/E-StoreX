import 'package:dio/dio.dart';
import 'package:ecommerce/features/basket/data/repo/basket_repo.dart';
import 'package:ecommerce/features/basket/logic/cubit/basket_cubit.dart';
import 'package:ecommerce/features/shop/brands/data/repo/brand_repo.dart';
import 'package:ecommerce/features/shop/brands/logic/cubit/brand_cubit.dart';
import 'package:ecommerce/features/order/data/repo/order_repo.dart';
import 'package:ecommerce/features/order/logic/cubit/order_cubit.dart';
import 'package:ecommerce/features/profile/data/repo/profile_repo.dart';
import 'package:ecommerce/features/profile/logic/cubit/profile_cubit.dart';
import 'package:get_it/get_it.dart';

// Services
import 'package:ecommerce/core/networking/estorex_api_service.dart';
import 'package:ecommerce/core/networking/dio_factory.dart';

// Home
import 'package:ecommerce/features/home/data/repos/home_repo.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';

// Categories
import 'package:ecommerce/features/shop/categories/logic/cubit/category_cubit.dart';
import 'package:ecommerce/features/shop/categories/data/repo/category_repo.dart';

// Search
import 'package:ecommerce/features/search/logic/cubit/search_cubit.dart';
import 'package:ecommerce/features/search/data/repo/search_repo.dart';

// Auth (Login/Register)
import 'package:ecommerce/features/auth/login/data/repo/login_repo.dart';
import 'package:ecommerce/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:ecommerce/features/auth/register/data/repo/register_repo.dart';
import 'package:ecommerce/features/auth/register/logic/cubit/register_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  // Dio and Api Service
  getIt.registerLazySingleton<Dio>(() => DioFactory.getDio());
  getIt.registerLazySingleton<EStoreXApiService>(
    () => EStoreXApiService(getIt<Dio>()),
  );

  // Home
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepo(apiService: getIt<EStoreXApiService>()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(homeRepo: getIt<HomeRepo>()),
  );

  // Categories
  getIt.registerLazySingleton<CategoryRepo>(
    () => CategoryRepo(apiService: getIt()),
  );
  getIt.registerFactory<CategoryCubit>(
    () => CategoryCubit(categoryRepo: getIt()),
  );
  // Brands
  getIt.registerLazySingleton<BrandRepo>(
    () => BrandRepo(apiService: getIt()),
  );
  getIt.registerFactory<BrandCubit>(
    () => BrandCubit(brandRepo: getIt()),
  );

  // Search
  getIt.registerLazySingleton<SearchRepo>(
    () => SearchRepo(apiService: getIt()),
  );
  getIt.registerFactory<SearchCubit>(() => SearchCubit(searchRepo: getIt()));

  //Basket
  getIt.registerLazySingleton<BasketRepo>(
    () => BasketRepo(apiService: getIt()),
  );
  getIt.registerFactory<BasketCubit>(() => BasketCubit(basketRepo: getIt()));
  //order
  getIt.registerLazySingleton<OrderRepo>(() => OrderRepo(apiService: getIt()));
  getIt.registerFactory<OrderCubit>(() => OrderCubit(getIt()));

  // Auth (Login & Register)
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerLazySingleton<RegisterRepo>(() => RegisterRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(loginRepo: getIt()));
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(registerRepo: getIt()),
  );

  // Profile
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepo(apiService: getIt()),
  );
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));


}
