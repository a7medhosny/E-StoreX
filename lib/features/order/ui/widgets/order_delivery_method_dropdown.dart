import 'package:ecommerce/core/widgets/custom_drop_down.dart';
import 'package:ecommerce/features/order/data/models/delivery_option.dart';
import 'package:flutter/material.dart';

class OrderDeliveryMethodDropdown extends StatelessWidget {
  final List<DeliveryOption> options;
  final String currentValue;
  final ValueChanged<String?> onChanged;

  const OrderDeliveryMethodDropdown({
    super.key,
    required this.options,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropDown(
      currentValue: currentValue,
      onChanged: onChanged,
      items:
          options.map((option) {
            return DropdownMenuEntry<String>(
              
              value: option.id ?? '',
              label: option.name ?? 'No Name',
              labelWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name ?? 'No Name',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Price: ${option.price?.toStringAsFixed(2) ?? "0.00"} USD',
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (option.deliveryTime?.isNotEmpty ?? false)
                    Text(
                      'Delivery Time: ${option.deliveryTime}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
