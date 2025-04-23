import 'package:flutter/material.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/theme/app_color.dart';

class AddProductsPage extends StatelessWidget {
  AddProductsPage({super.key});
  final _productName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Add products')),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: AppColors.gradientPrimary),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic information',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Form(
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomTextField(
                          label: 'Product name',
                          controller: _productName,
                        ),
                        CustomTextField(
                          label: 'Brand',
                          controller: _productName,
                        ),
                        CustomTextField(
                          label: 'Quantity',
                          controller: _productName,
                        ),
                        CustomTextField(
                          label: 'Product name',
                          controller: _productName,
                        ),
                        CustomTextField(
                          label: 'Product name',
                          controller: _productName,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
