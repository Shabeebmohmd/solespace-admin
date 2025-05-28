import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/category_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_card.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/core/widgets/dismissible_keyboard.dart';
import 'package:sole_space_admin/app/data/models/catogory_model.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
import 'package:sole_space_admin/utils/utils.dart';
import 'package:sole_space_admin/utils/validate_utils.dart';

/// A page that displays and manages all categories in a list view
class ManageCategoryPage extends StatelessWidget {
  ManageCategoryPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return DismissibleKeyboard(
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: _buildCategoryList(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: Text('Category management'),
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.addCategory),
          icon: Icon(
            Icons.add_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return Obx(
      () =>
          _categoryController.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _categoryController.categories.length,
                itemBuilder: (context, index) {
                  final category = _categoryController.categories[index];
                  return CategoryListItem(
                    category: category,
                    formKey: _formKey,
                    controller: _categoryController,
                  );
                },
              ),
    );
  }
}

/// Widget representing a single category item in the list
class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    super.key,
    required this.category,
    required this.formKey,
    required this.controller,
  });

  final Category category;
  final GlobalKey<FormState> formKey;
  final CategoryController controller;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: ListTile(
        title: Text(category.name),
        subtitle: Text(category.description ?? ''),
        trailing: _buildActionButtons(context),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEditButton(context),
        smallSpacing,
        _buildDeleteButton(context),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(8),
      child: IconButton(
        onPressed: () => _showEditDialog(context),
        icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(8),
      child: IconButton(
        onPressed: () => _showDeleteConfirmation(),
        icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(text: category.name);
    final descriptionController = TextEditingController(
      text: category.description,
    );

    Get.defaultDialog(
      title: 'Edit: ${category.name}',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      content: CategoryEditForm(
        formKey: formKey,
        nameController: nameController,
        descriptionController: descriptionController,
      ),
      onConfirm: () {
        if (formKey.currentState!.validate()) {
          controller.editCategory(
            category.id,
            nameController.text,
            descriptionController.text,
            null,
          );
          Get.back();
        }
      },
    );
  }

  void _showDeleteConfirmation() {
    Get.defaultDialog(
      title: 'Delete category',
      middleText: 'Are you sure you want to delete this category?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      onConfirm: () {
        controller.deleteCategory(category.id);
        Get.back();
      },
    );
  }
}

/// Form widget for editing a category
class CategoryEditForm extends StatelessWidget {
  const CategoryEditForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [_buildNameField(), mediumSpacing, _buildDescriptionField()],
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      label: 'Category name',
      controller: nameController,
      validator: (value) => ValidationUtils.validateRequired(value, 'Category'),
    );
  }

  Widget _buildDescriptionField() {
    return CustomTextField(
      label: 'Description',
      controller: descriptionController,
      maxLines: 3,
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Description'),
    );
  }
}
