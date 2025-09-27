import 'package:ecommerce/features/basket/logic/cubit/basket_cubit.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:ecommerce/features/shop/categories/ui/screens/categories_screen.dart';
import 'package:ecommerce/features/home/ui/screens/favourites_screen.dart';
import 'package:ecommerce/features/home/ui/screens/home_screen.dart';
import 'package:ecommerce/features/layout/logic/nav_cubit.dart';
import 'package:ecommerce/features/layout/ui/widgets/floating_nav_bar.dart';
import 'package:ecommerce/features/profile/ui/screens/profile_screen.dart';
import 'package:ecommerce/features/shop/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<BasketCubit>().initBasketItems();
      // context.read<HomeCubit>().getAllHomeData();

      // context.read<HomeCubit>().getFavorites();
    });

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // scroll down -> hide, scroll up -> show
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isNavVisible) {
        setState(() => _isNavVisible = false);
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isNavVisible) {
        setState(() => _isNavVisible = true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, int>(
      builder: (context, state) {
        final navCubit = context.read<NavCubit>();
        return Scaffold(
          body: _buildBody(navCubit, state),
          extendBody: true,
          bottomNavigationBar:
              _isNavVisible
                  ? AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _isNavVisible ? 1 : 0,
                    child: FloatingNavBar(
                      currentIndex: state,
                      onTap: (index) {
                        navCubit.changeTap(index);
                      },
                    ),
                  )
                  : null,
        );
      },
    );
  }

  Widget _buildBody(NavCubit navCubit, int state) {
    final List<Widget> screens = [
      HomeScreen(scrollController: _scrollController),
      ShopScreen(),
      FavouritesScreen(scrollController: _scrollController),
      ProfileScreen(),
    ];

    return SafeArea(child: screens[state]);
  }
}
