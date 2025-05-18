import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/product_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/data/models/product_model.dart';
import 'package:sole_space_admin/utils/utils.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({super.key});
  final Product product = Get.arguments;
  final _productController = Get.find<ProductController>();
  @override
  Widget build(BuildContext context) {
    final currentIndexNotifier = ValueNotifier<int>(0);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: Text('product details')),
        body: Obx(() {
          if (_productController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_productController.products.isEmpty) {
            return const Center(child: Text('No products available.'));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  product.imageUrls.isNotEmpty
                      ? _buildImage(currentIndexNotifier, product)
                      : _buildIcon(),
                  mediumSpacing,
                  _productName(),
                  mediumSpacing,
                  _productPrice(),
                  mediumSpacing,
                  _productDescription(),
                  mediumSpacing,
                  _buildSizes(context),
                  mediumSpacing,
                  _colorText(),
                  mediumSpacing,
                  _buildColors(context),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Wrap _buildColors(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children:
          product.colors
              .map(
                (color) => Chip(
                  label: Text(color),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  backgroundColor:
                      Theme.of(context).colorScheme.tertiaryFixedDim,
                ),
              )
              .toList(),
    );
  }

  Text _colorText() {
    return Text(
      'Available Colors:',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Wrap _buildSizes(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children:
          product.sizes
              .map(
                (size) => Chip(
                  label: Text(
                    size,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                ),
              )
              .toList(),
    );
  }

  Text _productDescription() =>
      Text(product.description, style: const TextStyle(fontSize: 16));

  Text _productPrice() {
    return Text(
      '\$${product.price.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 20,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Icon _buildIcon() => const Icon(Icons.image_not_supported, size: 100);

  Text _productName() {
    return Text(
      product.name,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildImage(ValueNotifier<int> currentIndexNotifier, Product product) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            enableInfiniteScroll: true,
            enlargeCenterPage: true,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 3),
            viewportFraction: 0.9,
            onPageChanged:
                (index, reason) => currentIndexNotifier.value = index,
          ),
          items:
              product.imageUrls.map((imageUrl) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100),
                  ),
                );
              }).toList(),
        ),
        buildIndicators(currentIndexNotifier, product),
      ],
    );
  }
}
