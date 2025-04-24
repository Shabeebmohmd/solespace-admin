import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/brand_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
// import 'package:sole_space_admin/app/theme/app_color.dart';

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
                : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 2,
                  ),
                  padding: const EdgeInsets.all(16),
                  itemCount: _brandController.brands.length,
                  itemBuilder: (context, index) {
                    final brand = _brandController.brands[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (brand.logoImage != null)
                          InkWell(
                            onTap: () {
                              Get.defaultDialog(
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text('Edit'),
                                        onTap: () {
                                          Get.back(); // Close the dialog
                                          final nameController =
                                              TextEditingController(
                                                text: brand.name,
                                              );
                                          final descriptionController =
                                              TextEditingController(
                                                text: brand.description,
                                              );
                                          _brandController.selectedImage.value =
                                              brand.logoImage;
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
                                                  GestureDetector(
                                                    onTap: () async {
                                                      _brandController
                                                          .pickImage();
                                                    },
                                                    child: Obx(
                                                      () => CircleAvatar(
                                                        radius: 50,
                                                        backgroundImage:
                                                            _brandController
                                                                        .selectedImage
                                                                        .value !=
                                                                    null
                                                                ? FileImage(
                                                                  _brandController
                                                                      .selectedImage
                                                                      .value!,
                                                                )
                                                                : AssetImage(
                                                                      'assets/images/Placeholder.jpeg',
                                                                    )
                                                                    as ImageProvider,
                                                        child:
                                                            _brandController
                                                                        .selectedImage
                                                                        .value ==
                                                                    null
                                                                ? Icon(
                                                                  Icons
                                                                      .add_a_photo,
                                                                  size: 30,
                                                                )
                                                                : null,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),
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
                                                    controller:
                                                        descriptionController,
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
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _brandController.editBrand(
                                                  brand.id,
                                                  nameController.text,
                                                  descriptionController.text,
                                                  _brandController
                                                      .selectedImage
                                                      .value,
                                                );
                                                Get.back();
                                              }
                                            },
                                          );
                                        },
                                      ),
                                      Divider(),
                                      ListTile(
                                        title: Text('Delete'),
                                        onTap: () {
                                          Get.back();
                                          Get.defaultDialog(
                                            title: 'Delete Brand',
                                            middleText:
                                                'Are you sure you want to delete this brand?',
                                            textConfirm: 'Delete',
                                            textCancel: 'Cancel',
                                            onConfirm: () {
                                              _brandController.deleteBrand(
                                                brand.id,
                                              );
                                              Get.back();
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(brand.logoImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
      ),
    );
  }
}
