import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sole_space_admin/app/data/models/product_model.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? validateBrand(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please Enter brand name';
  } else {
    return null;
  }
}

String? validateBrandDescription(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please Enter description';
  } else {
    return null;
  }
}

const SizedBox smallSpacing = SizedBox(height: 8);
const SizedBox mediumSpacing = SizedBox(height: 16);
const SizedBox extraMediumSpacing = SizedBox(height: 32);
const SizedBox largeSpacing = SizedBox(height: 48);

Widget buildButtonLoadingIndicator({
  double size = 20,
  Color indicatorColor = Colors.white,
  double strokeWidth = 2.0,
}) {
  return SizedBox(
    height: size,
    width: size,
    child: CircularProgressIndicator(
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
    ),
  );
}

Widget buildIndicators(
  ValueNotifier<int> currentIndexNotifier,
  Product product,
) {
  return ValueListenableBuilder<int>(
    valueListenable: currentIndexNotifier,
    builder: (context, currentIndex, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            product.imageUrls.asMap().entries.map((entry) {
              final index = entry.key;
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      currentIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                ),
              );
            }).toList(),
      );
    },
  );
}
