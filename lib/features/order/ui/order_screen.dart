import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/basket/logic/cubit/basket_cubit.dart';
import 'package:ecommerce/features/order/data/models/delivery_option.dart';
import 'package:ecommerce/features/order/data/models/shipping_address.dart';
import 'package:ecommerce/features/order/logic/cubit/order_cubit.dart';
import 'package:ecommerce/features/order/ui/widgets/order_form.dart';
import 'package:ecommerce/features/order/ui/widgets/order_payment_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedDeliveryMethodId;
  List<DeliveryOption> deliveryOptions = [];
  ShippingAddress? shippingAddress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderCubit>().getDeliveryMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Order'),
        centerTitle: true,
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) async {
          if (state is GetPaymentIntentDataSuccess) {
            if (shippingAddress == null || selectedDeliveryMethodId == null) {
              _showSnack(context, "Please complete the form", Colors.red);
              return;
            }
            await context.read<OrderCubit>().createOrder(
              basketId: TokenManager.userId ?? '',
              deliveryMethodId: selectedDeliveryMethodId!,
              shippingAddress: shippingAddress!,
            );
            context.read<OrderCubit>().makePayment(g
              paymentResponse: state.paymentResponse,
            );
          } else if (state is GetPaymentIntentDataError) {
            _showSnack(context, state.error, Colors.red);
          } else if (state is MakePaymentSuccess) {
            _showSnack(context, "Payment Success", Colors.green);
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.layoutScreen,
              (Route<dynamic> route) => false,
            );
          } else if (state is MakePaymentError) {
            _showSnack(context, "Payment Failed", Colors.red);
          }
        },
        builder: (context, state) {
          if (state is GetDeliveryMethodsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetDeliveryMethodsError) {
            return Center(child: Text('Failed: ${state.error}'));
          }

          if (state is GetDeliveryMethodsSuccess) {
            deliveryOptions = state.deliveryOptions;
            selectedDeliveryMethodId ??=
                deliveryOptions.isNotEmpty ? deliveryOptions.first.id : null;
          }

          return OrderForm(
            formKey: _formKey,
            options: deliveryOptions,
            selectedDeliveryMethodId: selectedDeliveryMethodId,
            onDeliveryChanged:
                (id) => setState(() => selectedDeliveryMethodId = id),
            onAddressChanged:
                (address) => setState(() => shippingAddress = address),
          );
        },
      ),
      bottomNavigationBar: OrderPaymentButton(
        formKey: _formKey,
        selectedDeliveryMethodId: selectedDeliveryMethodId,
      ),
    );
  }

  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
    );
  }
}
