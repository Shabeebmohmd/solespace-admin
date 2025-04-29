import 'package:flutter/material.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/theme/app_color.dart';
import 'package:sole_space_admin/utils/utils.dart';

class AddProductsPage extends StatelessWidget {
  AddProductsPage({super.key});
  final _productName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Add products')),
      body: SafeArea(
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
                    children: [
                      CustomTextField(
                        label: 'Product name',
                        controller: _productName,
                      ),
                      mediumSpacing,
                      CustomTextField(label: 'Brand', controller: _productName),
                      mediumSpacing,
                      CustomTextField(
                        label: 'Quantity',
                        controller: _productName,
                      ),
                      mediumSpacing,
                      CustomTextField(
                        label: 'Product name',
                        controller: _productName,
                      ),
                      mediumSpacing,
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
    );
  }
}
