import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/category_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_button.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/core/widgets/dismissible_keyboard.dart';
import 'package:sole_space_admin/utils/utils.dart';
import 'package:sole_space_admin/utils/validate_utils.dart';

/// A page that allows users to add a new category with name and description.
class AddCategoryPage extends StatelessWidget {
  AddCategoryPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return DismissibleKeyboard(
      child: Scaffold(
        appBar: CustomAppBar(title: Text('Add category')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CategoryForm(
              formKey: _formKey,
              controller: _categoryController,
            ),
          ),
        ),
      ),
    );
  }
}

/// Form widget for adding a new category
class CategoryForm extends StatelessWidget {
  const CategoryForm({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final GlobalKey<FormState> formKey;
  final CategoryController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CategoryNameField(controller: controller),
          mediumSpacing,
          CategoryDescriptionField(controller: controller),
          extraMediumSpacing,
          AddCategoryButton(formKey: formKey, controller: controller),
        ],
      ),
    );
  }
}

/// Widget for category name input field
class CategoryNameField extends StatelessWidget {
  const CategoryNameField({super.key, required this.controller});

  final CategoryController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Category name',
      controller: controller.nameController,
      validator: (value) => ValidationUtils.validateRequired(value, 'Category'),
    );
  }
}

/// Widget for category description input field
class CategoryDescriptionField extends StatelessWidget {
  const CategoryDescriptionField({super.key, required this.controller});

  final CategoryController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Description',
      controller: controller.descriptionController,
      maxLines: 3,
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Description'),
    );
  }
}

/// Widget for the add category button
class AddCategoryButton extends StatelessWidget {
  const AddCategoryButton({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final GlobalKey<FormState> formKey;
  final CategoryController controller;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Add category',
      onPressed: () {
        if (formKey.currentState!.validate()) {
          controller.addCategory(
            controller.nameController.text,
            controller.descriptionController.text,
            null,
          );
          Get.back();
        }
      },
      isLoading: controller.isLoading.value,
    );
  }
}
