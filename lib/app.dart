import 'package:ecommerce/core/DI/get_it.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/features/basket/data/repo/basket_repo.dart';
import 'package:ecommerce/features/basket/logic/cubit/basket_cubit.dart';
import 'package:ecommerce/features/layout/ui/layout_screen.dart';
import 'package:ecommerce/features/shop/brands/logic/cubit/brand_cubit.dart';
import 'package:ecommerce/features/order/logic/cubit/order_cubit.dart';
import 'package:ecommerce/features/profile/logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ecommerce/core/routing/app_router.dart';
import 'package:ecommerce/core/routing/routes.dart';

// Cubits
import 'package:ecommerce/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:ecommerce/features/auth/register/logic/cubit/register_cubit.dart';
import 'package:ecommerce/features/shop/categories/logic/cubit/category_cubit.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:ecommerce/features/search/logic/cubit/search_cubit.dart';
import 'package:ecommerce/features/layout/logic/nav_cubit.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.appRouter});
  final AppRouter appRouter;

  bool isUserLoggedIn =
      TokenManager.token != null || TokenManager.guestId != null;

  @override
  Widget build(BuildContext context) {
    // print("MyApp: Initial Route: $initialRoute");
    print("MyApp: Token: ${TokenManager.token}");
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<HomeCubit>()),
            BlocProvider(create: (_) => getIt<RegisterCubit>()),
            BlocProvider(create: (_) => getIt<ProfileCubit>()),

            BlocProvider(
              create: (_) => getIt<CategoryCubit>(),
              // ..getAllCategories(),
            ),
            BlocProvider(create: (_) => getIt<SearchCubit>()),
            BlocProvider(create: (_) => getIt<OrderCubit>()),
            BlocProvider(create: (_) => getIt<LoginCubit>()),
            BlocProvider(create: (_) => getIt<BasketCubit>()..initBasketItems()),
            BlocProvider(create: (context) => getIt<BrandCubit>()),

            BlocProvider(create: (_) => NavCubit()),
          ],
          child:
              isUserLoggedIn
                  ? MaterialApp(
                    debugShowCheckedModeBanner: false,
                    onGenerateRoute: appRouter.onGenerateRoute,

                    home: const LayoutScreen(),
                  )
                  : MaterialApp(
                    debugShowCheckedModeBanner: false,
                    onGenerateRoute: appRouter.onGenerateRoute,
                    initialRoute: Routes.onBoarding,
                  ),
        );
      },
    );
  }
}
