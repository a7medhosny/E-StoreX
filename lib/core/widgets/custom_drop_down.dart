import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final String currentValue;
  final ValueChanged<String?> onChanged;
  final List<DropdownMenuEntry<String>> items;
  final double height;
  final double borderRadius;
  final Color borderColor;
  final IconData icon;

  const CustomDropDown({
    Key? key,
    required this.currentValue,
    required this.onChanged,
    required this.items,
    this.height = 40,
    this.borderRadius = 8,
    this.borderColor = Colors.grey,
    this.icon = Icons.keyboard_arrow_down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      enableSearch: false,
      enableFilter: false,
      initialSelection: currentValue,
      onSelected: onChanged,
      dropdownMenuEntries: items,
      label: const Text('Select Delivery Method'),
      expandedInsets: EdgeInsets.zero,
      width: MediaQuery.of(context).size.width - 32,
    );
  }
}
