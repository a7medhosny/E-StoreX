import 'package:ecommerce/core/helpers/spacing.dart';
import 'package:ecommerce/features/order/data/models/delivery_option.dart';
import 'package:ecommerce/features/order/data/models/shipping_address.dart';
import 'package:ecommerce/features/order/ui/widgets/order_delivery_method_dropdown.dart';
import 'package:ecommerce/features/order/ui/widgets/order_text_field.dart';
import 'package:flutter/material.dart';

class OrderForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<DeliveryOption> options;
  final String? selectedDeliveryMethodId;
  final ValueChanged<String?> onDeliveryChanged;
  final ValueChanged<ShippingAddress> onAddressChanged;

  const OrderForm({
    super.key,
    required this.formKey,
    required this.options,
    required this.selectedDeliveryMethodId,
    required this.onDeliveryChanged,
    required this.onAddressChanged,
  });

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  // Controllers هنا
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _streetController = TextEditingController();
  final _stateController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _streetController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  void _updateAddress() {
    widget.onAddressChanged(
      ShippingAddress(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        city: _cityController.text,
        state: _stateController.text,
        street: _streetController.text,
        zipCode: _zipCodeController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: widget.formKey,
        onChanged: _updateAddress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OrderTextField(
              label: "First Name",
              controller: _firstNameController,
            ),
            verticalSpace(16),
            OrderTextField(label: "Last Name", controller: _lastNameController),
            verticalSpace(16),
            OrderTextField(label: "City", controller: _cityController),
            verticalSpace(16),
            OrderTextField(
              label: "Zip Code",
              controller: _zipCodeController,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Enter Zip Code";
                }
                if (!RegExp(r'^\d{5,10}$').hasMatch(v)) {
                  return "Zip Code must be between 5 and 10 digits";
                }
                return null;
              },
            ),

            verticalSpace(16),
            OrderTextField(label: "Street", controller: _streetController),
            verticalSpace(16),
            OrderTextField(label: "State", controller: _stateController),
            verticalSpace(16),
            OrderDeliveryMethodDropdown(
              options: widget.options,
              currentValue: widget.selectedDeliveryMethodId ?? '',
              onChanged: widget.onDeliveryChanged,
            ),
          ],
        ),
      ),
    );
  }
}
