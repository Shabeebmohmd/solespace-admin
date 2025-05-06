import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/brand_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/core/widgets/dismissible_keyboard.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
import 'package:sole_space_admin/utils/validate_utils.dart';
// import 'package:sole_space_admin/app/theme/app_color.dart';

class ManageBrandPage extends StatelessWidget {
  ManageBrandPage({super.key});
  final _brandController = Get.find<BrandController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DismissibleKeyboard(
      child: Scaffold(
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
                      childAspectRatio: 1.0,
                    ),
                    padding: const EdgeInsets.all(16),
                    itemCount: _brandController.brands.length,
                    itemBuilder: (context, index) {
                      final brand = _brandController.brands[index];
                      return Column(
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
                                            _brandController
                                                .clearSelectedImage();
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
                                                    Obx(
                                                      () => GestureDetector(
                                                        onTap: () async {
                                                          _brandController
                                                              .pickImage(); // Trigger image picker
                                                        },
                                                        child: CircleAvatar(
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
                                                                  ) // Show selected image
                                                                  : (brand.logoImage != null &&
                                                                          brand.logoImage!.isNotEmpty
                                                                      ? NetworkImage(
                                                                        brand
                                                                            .logoImage!,
                                                                      ) // Show existing Cloudinary image
                                                                      : AssetImage(
                                                                            'assets/images/Placeholder.jpeg',
                                                                          )
                                                                          as ImageProvider), // Fallback to placeholder
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(height: 16),
                                                    CustomTextField(
                                                      label: 'Brand name',
                                                      controller:
                                                          nameController,
                                                      validator:
                                                          (value) =>
                                                              ValidationUtils.validateRequired(
                                                                value,
                                                                'Brand name',
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        shape:
                                            BoxShape
                                                .circle, // Make the container circular
                                        image: DecorationImage(
                                          image: NetworkImage(brand.logoImage!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ), // Add spacing between the circle and the text
                                  Text(
                                    brand.name,
                                    style: TextStyle(
                                      color:
                                          Colors
                                              .black, // Use a visible color for the text
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
