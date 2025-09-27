import 'package:ecommerce/features/basket/ui/screens/basket_screen.dart';
import 'package:ecommerce/features/shop/brands/ui/brand_screen.dart';
import 'package:ecommerce/features/shop/brands/ui/view_all_broducts_by_brand_name_screen.dart';
import 'package:ecommerce/features/shop/categories/ui/screens/categories_screen.dart';
import 'package:ecommerce/features/shop/categories/ui/screens/view_all_products_by_category_screen.dart';
import 'package:ecommerce/features/home/ui/screens/filters_screen.dart';
import 'package:ecommerce/features/order/ui/order_screen.dart';
import 'package:ecommerce/features/order/ui/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/auth/forget_password.dart';
import 'package:ecommerce/features/profile/ui/screens/reset_password.dart';
import 'package:ecommerce/features/auth/login/ui/screens/login_screen.dart';
import 'package:ecommerce/features/auth/register/ui/screens/register_screen.dart';
import 'package:ecommerce/features/auth/login_register_tap_switcher.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/ui/screens/image_screen.dart';
import 'package:ecommerce/features/home/ui/screens/product_details_screen.dart';
import 'package:ecommerce/features/home/ui/screens/view_all_products_screen.dart';
import 'package:ecommerce/features/layout/ui/layout_screen.dart';
import 'package:ecommerce/features/onboarding/onboarding_screen.dart';
import 'package:ecommerce/features/onboarding/onboarding_second_screen.dart';
import 'package:ecommerce/features/search/ui/screens/search_screen.dart';

class AppRouter {
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.layoutScreen:
        return MaterialPageRoute(builder: (_) => const LayoutScreen());

      case Routes.productDetails:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );

      case Routes.imageScreen:
        final photos = settings.arguments as List<PhotoModel>;
        return MaterialPageRoute(builder: (_) => ImageScreen(photos: photos));

      case Routes.viewAllProducts:
        return MaterialPageRoute(builder: (_) => ViewAllProductsScreen());
      case Routes.viewAllProductsByCategoryScreen:
        return MaterialPageRoute(
          builder: (_) => const ViewAllProductsByCategoryScreen(),
        );
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case Routes.loginRegisterTabSwitcher:
        final initialTabIsLogin =
            settings.arguments is bool ? settings.arguments as bool : true;
        return MaterialPageRoute(
          builder:
              (_) => LoginRegisterTabSwitcher(
                initialTabIsLogin: initialTabIsLogin,
              ),
        );
      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      case Routes.search:
        return MaterialPageRoute(builder: (_) => SearchScreen());

      case Routes.filterScreen:
        return MaterialPageRoute(builder: (_) => FiltersScreen());

      case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.onBoardingSecond:
        return MaterialPageRoute(
          builder: (_) => const OnboardingSecondScreen(),
        );
      case Routes.orderScreen:
        // final String basketId =settings.arguments as String;
        return MaterialPageRoute(builder: (_) => OrderScreen());

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());

      // Deep links مثل: /?userId=xxx&token=xxx
      case Routes.initial:
      case Routes.resetPassword:
        final args = settings.arguments as Map<String, dynamic>?;
        final userId = args?['userId'];
        final token = args?['token'];

        if (userId != null && token != null) {
          return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
        } else {
          return MaterialPageRoute(builder: (_) => const LayoutScreen());
        }

      case Routes.basketScreen:
        return MaterialPageRoute(builder: (_) => const BasketScreen());
      case Routes.ordersScreen:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case Routes.categorysScreen:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case Routes.brandsScreen:
        return MaterialPageRoute(builder: (_) => const BrandsScreen());
      case Routes.viewAllProductsByBrandNameScreen:
        return MaterialPageRoute(
          builder: (_) => const ViewAllProductsByBrandNameScreen(),
        );

      default:
        return null;
    }
  }
}
