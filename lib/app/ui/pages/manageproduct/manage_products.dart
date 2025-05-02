import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/product_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_card.dart';
import 'package:sole_space_admin/app/core/widgets/custom_dialog.dart';
import 'package:sole_space_admin/app/data/models/product_model.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
import 'package:sole_space_admin/utils/utils.dart';

class ManageProductsPage extends StatelessWidget {
  ManageProductsPage({super.key});
  final _productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Manage products')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.addProducts),
        label: Row(children: [Icon(Icons.add), Text('Add new product')]),
      ),
      body: Obx(() {
        if (_productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_productController.products.isEmpty) {
          return const Center(child: Text('No products available.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.5,
          ),
          itemCount: _productController.products.length,
          itemBuilder: (context, index) {
            final product = _productController.products[index];
            return InkWell(
              onTap: () {
                Get.defaultDialog(
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _buildEdit(product),
                        Divider(),
                        _buildDelete(product),
                      ],
                    ),
                  ),
                );
              },
              child: _buildCard(product),
            );
          },
        );
      }),
    );
  }

  CustomCard _buildCard(Product product) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            product.imageUrls.isNotEmpty
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Set the border radius
                  child: Image.network(
                    product.imageUrls[0],
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                  ),
                )
                : const Icon(Icons.image_not_supported, size: 100),
            smallSpacing,
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallSpacing,
                Text(
                  'Brand: ${_productController.getBrandName(product.brandId)}',
                ),
                Text(
                  'Category: ${_productController.getCategoryName(product.categoryId)}',
                ),
                Text('Price: \$${product.price.toStringAsFixed(2)}'),
                Text('Stock: ${product.stockQuantity}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildDelete(Product product) {
    return ListTile(
      title: Text('Delete'),
      onTap: () {
        Get.back();
        // Get.defaultDialog(
        //   title: 'Delete product',
        //   middleText: 'Are you sure you want to delete this product?',
        //   textConfirm: 'Delete',
        //   textCancel: 'Cancel',
        //   onConfirm: () async {
        //     Get.back();
        //     await _productController.deleteProduct(product.id!);
        //   },
        // );
        CustomDialog.showConfirmation(
          title: 'Delete product',
          message: 'Are you sure you want to delete this product?',
          onConfirm: () async {
            await _productController.deleteProduct(product.id!);
          },
        );
      },
    );
  }

  ListTile _buildEdit(Product product) {
    return ListTile(
      title: Text('Edit'),
      onTap: () {
        Get.back();
        Get.toNamed(
          AppRoutes.editProducts,
          arguments: product,
        ); // Close the dialog
      },
    );
  }
}
