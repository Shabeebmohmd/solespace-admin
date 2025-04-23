import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/brand_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_card.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';

class ManageBrandPage extends StatelessWidget {
  ManageBrandPage({super.key});
  final _brandController = Get.find<BrandController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Brand management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.addBrand),
        label: Row(children: [Icon(Icons.add), Text('Add new brand')]),
      ),
      body: Obx(
        () =>
            _brandController.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: _brandController.brands.length,
                  itemBuilder: (context, index) {
                    final brand = _brandController.brands[index];
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: CustomCard(
                        child: ListTile(
                          title: Text(brand.name),
                          subtitle: Text(brand.description ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  final nameController = TextEditingController(
                                    text: brand.name,
                                  );
                                  final descriptionController =
                                      TextEditingController(
                                        text: brand.description,
                                      );
                                  Get.defaultDialog(
                                    title: 'Edit: ${brand.name}',
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
                                            label: 'Brand name',
                                            controller: nameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter brand name';
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
                                        _brandController.editBrand(
                                          brand.id,
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
                                    title: 'Delete Brand',
                                    middleText:
                                        'Are you sure you want to delete this brand?',
                                    textConfirm: 'Delete',
                                    textCancel: 'cancel',
                                    onConfirm: () {
                                      _brandController.deleteBrand(brand.id);
                                      Get.back();
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
