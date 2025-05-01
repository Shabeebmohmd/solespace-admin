// lib/app/core/widgets/custom_dialog.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/core/widgets/custom_button.dart';

class CustomDialog {
  static Future<void> show({
    String title = '',
    String message = '',
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCancel = true,
  }) async {
    return Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (showCancel)
            CustomButton(
              onPressed: () {
                Get.back();
                if (onCancel != null) onCancel();
              },
              text: cancelText,
              variant: CustomButtonVariant.outline,
            ),
          CustomButton(
            onPressed: () {
              Get.back();
              if (onConfirm != null) onConfirm();
            },
            text: confirmText,
          ),
        ],
      ),
    );
  }

  static Future<void> showError({
    String title = 'Error',
    required String message,
    String buttonText = 'OK',
  }) async {
    return show(
      title: title,
      message: message,
      confirmText: buttonText,
      showCancel: false,
    );
  }

  static Future<void> showSuccess({
    String title = 'Success',
    required String message,
    String buttonText = 'OK',
  }) async {
    return show(
      title: title,
      message: message,
      confirmText: buttonText,
      showCancel: false,
    );
  }

  static Future<void> showConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    return show(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
    );
  }
}
