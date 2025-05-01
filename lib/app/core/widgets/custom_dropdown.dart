import 'package:flutter/material.dart';
import 'package:sole_space_admin/app/theme/app_color.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final String? hintText;
  final List<Map<String, dynamic>> items;
  final Function(String?) onChanged;
  final String itemIdKey;
  final String itemDisplayKey;
  final String? Function(String?)? validator;

  const CustomDropdown({
    super.key,
    required this.value,
    this.hintText,
    required this.items,
    required this.onChanged,
    this.itemIdKey = 'id',
    this.itemDisplayKey = 'name',
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value?.isEmpty ?? true ? null : value,
      // hint: Text(hintText),
      items:
          items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item[itemIdKey] as String,
                  child: Text(item[itemDisplayKey] as String),
                ),
              )
              .toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: hintText,
        hintStyle: TextStyle(color: AppColors.smallTexts, fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
