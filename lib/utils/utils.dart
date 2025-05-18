import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
