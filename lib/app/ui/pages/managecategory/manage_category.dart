import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/category_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_card.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/core/widgets/dismissible_keyboard.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
import 'package:sole_space_admin/utils/validate_utils.dart';

class ManageCategoryPage extends StatelessWidget {
  ManageCategoryPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return DismissibleKeyboard(
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text('Category management'),
            actions: [
              IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.addCategory);
                },
                icon: Icon(
                  Icons.add_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          body: Obx(
            () =>
                _categoryController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount: _categoryController.categories.length,
                      itemBuilder: (context, index) {
                        final category = _categoryController.categories[index];
                        return CustomCard(
                          child: ListTile(
                            title: Text(category.name),
                            subtitle: Text(category.description ?? ''),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(8),
                                  child: IconButton(
                                    onPressed: () {
                                      final nameController =
                                          TextEditingController(
                                            text: category.name,
                                          );
                                      final descriptionController =
                                          TextEditingController(
                                            text: category.description,
                                          );
                                      Get.defaultDialog(
                                        title: 'Edit: ${category.name}',
                                        titleStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textConfirm: 'Save',
                                        textCancel: 'Cancel',
                                        content: Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              CustomTextField(
                                                label: 'Category name',
                                                controller: nameController,
                                                validator:
                                                    (value) =>
                                                        ValidationUtils.validateRequired(
                                                          value,
                                                          'Category',
                                                        ),
                                              ),
                                              SizedBox(height: 16),
                                              CustomTextField(
                                                label: 'Description',
                                                controller:
                                                    descriptionController,
                                                maxLines: 3,
                                                validator:
                                                    (value) =>
                                                        ValidationUtils.validateRequired(
                                                          value,
                                                          'Description',
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onConfirm: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _categoryController.editCategory(
                                              category.id,
                                              nameController.text,
                                              descriptionController.text,
                                              null,
                                            );
                                            Get.back();
                                          }
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(8),
                                  child: IconButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: 'Delete category',
                                        middleText:
                                            'Are you sure you want to delete this category?',
                                        textConfirm: 'Delete',
                                        textCancel: 'cancel',
                                        onConfirm: () {
                                          _categoryController.deleteCategory(
                                            category.id,
                                          );
                                          Get.back();
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ),
      ),
    );
  }
}
