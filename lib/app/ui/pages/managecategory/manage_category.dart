import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/category_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_card.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';

class ManageCategoryPage extends StatelessWidget {
  ManageCategoryPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Category management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.addCategory),
        label: Row(children: [Icon(Icons.add), Text('Add new category')]),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                final nameController = TextEditingController(
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
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Enter category name';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        CustomTextField(
                                          label: 'Description',
                                          controller: descriptionController,
                                          maxLines: 3,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Enter description';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  onConfirm: () {
                                    if (_formKey.currentState!.validate()) {
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
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
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
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
