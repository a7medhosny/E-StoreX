import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key,required this.onChanged});
final Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onChanged,
      style: TextStyle(fontSize: 16.0, color: Colors.black87),
    );
  }
}