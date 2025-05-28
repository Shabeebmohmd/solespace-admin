import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/brand_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_button.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/core/widgets/dismissible_keyboard.dart';
import 'package:sole_space_admin/utils/utils.dart';

/// A page that allows users to add a new brand with name, description and image.
class AddBrandsPage extends StatelessWidget {
  AddBrandsPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final brandController = Get.find<BrandController>();

  @override
  Widget build(BuildContext context) {
    return DismissibleKeyboard(
      child: Scaffold(
        appBar: CustomAppBar(title: Text('Add brand')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BrandForm(
              formKey: _formKey,
              brandController: brandController,
            ),
          ),
        ),
      ),
    );
  }
}

/// Form widget for adding a new brand
class BrandForm extends StatelessWidget {
  const BrandForm({
    super.key,
    required this.formKey,
    required this.brandController,
  });

  final GlobalKey<FormState> formKey;
  final BrandController brandController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          BrandImagePicker(controller: brandController),
          const SizedBox(height: 16),
          BrandNameField(controller: brandController),
          const SizedBox(height: 16),
          BrandDescriptionField(controller: brandController),
          const SizedBox(height: 24),
          AddBrandButton(formKey: formKey, controller: brandController),
        ],
      ),
    );
  }
}

/// Widget for picking and displaying brand image
class BrandImagePicker extends StatelessWidget {
  const BrandImagePicker({super.key, required this.controller});

  final BrandController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: controller.pickImage,
        child: CircleAvatar(
          radius: 80,
          backgroundImage:
              controller.selectedImage.value != null
                  ? FileImage(controller.selectedImage.value!)
                  : null,
          child:
              controller.selectedImage.value == null
                  ? const Icon(Icons.add_a_photo, size: 30)
                  : null,
        ),
      );
    });
  }
}

/// Widget for brand name input field
class BrandNameField extends StatelessWidget {
  const BrandNameField({super.key, required this.controller});

  final BrandController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Brand name',
      controller: controller.nameController,
      validator: (value) => validateBrand(value),
    );
  }
}

/// Widget for brand description input field
class BrandDescriptionField extends StatelessWidget {
  const BrandDescriptionField({super.key, required this.controller});

  final BrandController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Description',
      controller: controller.descriptionController,
      maxLines: 3,
      validator: (value) => validateBrandDescription(value),
    );
  }
}

/// Widget for the add brand button
class AddBrandButton extends StatelessWidget {
  const AddBrandButton({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final GlobalKey<FormState> formKey;
  final BrandController controller;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Add brand',
      onPressed: () {
        if (formKey.currentState!.validate()) {
          controller.addBrand(
            controller.nameController.text,
            controller.descriptionController.text,
            controller.selectedImage.value,
          );
          controller.selectedImage.value = null;
          Get.back();
        }
      },
      isLoading: controller.isLoading.value,
    );
  }
}
