import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/brand_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_button.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/utils/utils.dart';

class AddBrandsPage extends StatelessWidget {
  AddBrandsPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final brandController = Get.find<BrandController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Add brand')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Obx(() {
                  return GestureDetector(
                    onTap: brandController.pickImage,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          brandController.selectedImage.value != null
                              ? FileImage(brandController.selectedImage.value!)
                              : null,
                      child:
                          brandController.selectedImage.value == null
                              ? Icon(Icons.add_a_photo, size: 30)
                              : null,
                    ),
                  );
                }),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Brand name',
                  controller: _nameController,
                  validator: (value) => validateBrand(value),
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 3,
                  validator: (value) => validateBrandDescription(value),
                ),
                SizedBox(height: 24),
                CustomButton(
                  text: 'Add brand',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      brandController.addBrand(
                        _nameController.text,
                        _descriptionController.text,
                        brandController.selectedImage.value,
                      );
                      brandController.selectedImage.value = null;
                      Get.back();
                    }
                  },
                  isLoading: brandController.isLoading.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
