import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/auth_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_button.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/core/widgets/dismissible_keyboard.dart';
import 'package:sole_space_admin/utils/utils.dart';
import 'package:sole_space_admin/utils/validate_utils.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return DismissibleKeyboard(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // For web, center the form and restrict its max width
                  double maxWidth =
                      constraints.maxWidth > 600 ? 400 : double.infinity;
                  return SizedBox(
                    width: maxWidth,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildText(context),
                          extraMediumSpacing,
                          _buildEmailField(),
                          mediumSpacing,
                          Obx(
                            () => Column(
                              children: [
                                _buildPasswordField(),
                                largeSpacing,
                                _buildLoginButton(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  CustomButton _buildLoginButton() {
    return CustomButton(
      text: 'Login',
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _authController.logIn(
            _emailController.text.trim(),
            _passwordController.text,
          );
        }
      },
      isLoading: _authController.isLoading.value,
    );
  }

  CustomTextField _buildPasswordField() {
    return CustomTextField(
      label: 'Password',
      // hint: 'Password',
      controller: _passwordController,
      prefixIcon: IconButton(
        onPressed: () {
          _authController.togglePasswordVisibility();
        },
        icon: Icon(
          _authController.isPasswordVisible.value
              ? Icons.lock
              : Icons.lock_open,
        ),
      ),
      obscureText: _authController.isPasswordVisible.value,
      validator: (value) => ValidationUtils.validatePassword(value),
    );
  }

  CustomTextField _buildEmailField() {
    return CustomTextField(
      label: 'Email',
      controller: _emailController,
      prefixIcon: const Icon(Icons.email),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => ValidationUtils.validateEmail(value),
    );
  }

  Text _buildText(BuildContext context) {
    return Text(
      'Admin Login',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        // color: Colors.blueAccent,
      ),
      textAlign: TextAlign.center,
    );
  }
}
