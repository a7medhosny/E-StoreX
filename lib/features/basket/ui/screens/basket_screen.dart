import 'package:ecommerce/core/helpers/spacing.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/basket/logic/cubit/basket_cubit.dart';
import 'package:ecommerce/features/basket/ui/widgets/basket_app_bar.dart';
import 'package:ecommerce/features/basket/ui/widgets/basket_bottom_nav.dart';
import 'package:ecommerce/features/basket/ui/widgets/basket_item_card.dart';
import 'package:ecommerce/features/basket/ui/widgets/basket_summary_row.dart';
import 'package:ecommerce/features/layout/logic/nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  final TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BasketCubit>().getBasketByCustomerId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<BasketCubit, BasketState>(
          listener: (context, state) {
            if (state is BasketError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is BasketItemRemovedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item removed from basket!')),
              );
            } else if (state is BasketItemQuantityUpdatedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quantity updated!')),
              );
            }
            if (state is ApplyDiscountCodeError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          buildWhen:
              (previous, current) =>
                  current is BasketLoading ||
                  current is BasketLoaded ||
                  current is BasketError,
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                const BasketAppBar(),

                if (state is BasketLoading)
                  _basketLoadingState()
                else if (state is BasketError)
                  _basketErrorState(message: state.message)
                else if (state is BasketLoaded)
                  if (state.basketModel.basketItems == null ||
                      state.basketModel.basketItems!.isEmpty)
                    _basketEmptyState()
                  else ...[
                    // Items List
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final basketItem =
                            state.basketModel.basketItems![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: BasketItemCard(
                            basketItem: basketItem,
                            basketId: state.basketModel.id ?? '',
                            onRemove: () {
                              _confirmRemoval(
                                context,
                                basketItem.id ?? '',
                                basketItem.name ?? '',
                                state.basketModel.id ?? '',
                              );
                            },
                          ),
                        );
                      }, childCount: state.basketModel.basketItems!.length),
                    ),

                    // Basket Summary
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(thickness: 1),
                            Text(
                              "Basket Summary",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),

                            // Discount Field
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    enabled: TokenManager.token != null,
                                    controller: _discountController,
                                    decoration: InputDecoration(
                                      hintText: "Enter discount code",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    if (TokenManager.token != null) {
                                      context
                                          .read<BasketCubit>()
                                          .applyDiscountCode(
                                            code:
                                                _discountController.text.trim(),
                                            basketId:
                                                state.basketModel.id ?? '',
                                          );
                                    } else {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.loginRegisterTabSwitcher,
                                      );
                                    }
                                  },

                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child:
                                      context.watch<BasketCubit>().state
                                              is ApplyDiscountCodeLoading
                                          ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : const Text("Apply"),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            BasketSummaryRow(
                              title: "Total",
                              value: "${state.basketModel.total ?? 0} EGP",
                            ),
                            BasketSummaryRow(
                              title: "Discount",
                              value:
                                  "${state.basketModel.discountValue ?? 0} EGP",
                            ),
                            BasketSummaryRow(
                              title: "Discount %",
                              value:
                                  "${state.basketModel.percentage?.toStringAsFixed(1) ?? "0"}%",
                            ),
                            BasketSummaryRow(
                              title: "Final Price",
                              value:
                                  "${(state.basketModel.total ?? 0) - (state.basketModel.discountValue ?? 0)} EGP",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                else
                  const SliverFillRemaining(
                    child: Center(child: Text('Loading basket...')),
                  ),
              ],
            );
          },
        ),
      ),

      bottomNavigationBar: BasketBottomNav(),
    );
  }

  _basketLoadingState() {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  _basketEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_basket_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your basket is empty!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                context.read<NavCubit>().reset();
                Navigator.pop(context);
              },
              child: const Text('Shop Now'),
            ),
          ],
        ),
      ),
    );
  }

  _basketErrorState({required String message}) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Failed to load basket: $message',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<BasketCubit>().getBasketByCustomerId();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------
  // Confirmation Dialog for Removal
  // -------------------------------
  Future<void> _confirmRemoval(
    BuildContext context,
    String productId,
    String productName,
    String basketId,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: Text(
            'Are you sure you want to remove "$productName" from your basket?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      context.read<BasketCubit>().removeItemFromBasket(
        basketId: basketId,
        productId: productId,
      );
    }
  }
}
