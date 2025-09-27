import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/features/order/logic/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPaymentButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String? selectedDeliveryMethodId;

  const OrderPaymentButton({
    super.key,
    required this.formKey,
    required this.selectedDeliveryMethodId,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.watch<OrderCubit>().state is GetPaymentIntentDataLoading;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed:
            isLoading
                ? null
                : () {
                  
                  if (formKey.currentState!.validate()) {
                    if (selectedDeliveryMethodId != null) {
                      context.read<OrderCubit>().getPaymentIntentData(
                        basketId: TokenManager.userId ?? '',
                        deliveryMethodId: selectedDeliveryMethodId!,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Select delivery method")),
                      );
                    }
                  }
                },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child:
            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  "Proceed to Payment",
                  style: TextStyle(fontSize: 18),
                ),
      ),
    );
  }
}
