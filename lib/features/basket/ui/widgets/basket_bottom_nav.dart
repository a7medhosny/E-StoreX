import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/features/basket/logic/cubit/basket_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routing/routes.dart';

class BasketBottomNav extends StatelessWidget {
  const BasketBottomNav({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketCubit, BasketState>(
      buildWhen:
              (previous, current) =>
                  current is BasketLoading ||
                  current is BasketLoaded ||
                  current is BasketError,
      builder: (context, state) {
        if (state is BasketLoaded &&
            state.basketModel.basketItems != null &&
            state.basketModel.basketItems!.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (TokenManager.token != null &&
                    TokenManager.token!.isNotEmpty) {
                  Navigator.of(context).pushNamed(Routes.orderScreen);
                } else {
                  Navigator.pushNamed(context, Routes.loginRegisterTabSwitcher);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Proceed to checkout',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
