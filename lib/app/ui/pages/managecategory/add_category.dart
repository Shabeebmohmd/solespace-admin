import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/category_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_button.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/core/widgets/dismissible_keyboard.dart';
import 'package:sole_space_admin/utils/utils.dart';
import 'package:sole_space_admin/utils/validate_utils.dart';

class AddCategoryPage extends StatelessWidget {
  AddCategoryPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return DismissibleKeyboard(
      child: Scaffold(
        appBar: CustomAppBar(title: Text('Add category')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _categoryName(),
                  mediumSpacing,
                  _description(),
                  extraMediumSpacing,
                  _buildAddButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CustomTextField _description() {
    return CustomTextField(
      label: 'Description',
      controller: _descriptionController,
      maxLines: 3,
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Description'),
    );
  }

  CustomTextField _categoryName() {
    return CustomTextField(
      label: 'Category name',
      controller: _nameController,
      validator: (value) => ValidationUtils.validateRequired(value, 'Category'),
    );
  }

  CustomButton _buildAddButton() {
    return CustomButton(
      text: 'Add category',
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _categoryController.addCategory(
            _nameController.text,
            _descriptionController.text,
            null,
          );
          Get.back();
        }
      },
      isLoading: _categoryController.isLoading.value,
    );
  }
}
