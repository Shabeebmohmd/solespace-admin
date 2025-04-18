import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/auth_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_button.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Admin Login',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    prefixIcon: const Icon(Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your Email';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CustomTextField(
                      label: 'Password',
                      // hint: 'Password',
                      controller: _passwordController,
                      prefixIcon: IconButton(
                        onPressed: () {
                          _authController.togglePasswordVisibility();
                        },
                        icon: Icon(
                          _authController.isPasswordvisible.value
                              ? Icons.lock
                              : Icons.lock_open,
                        ),
                      ),
                      obscureText: _authController.isPasswordvisible.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter you password';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _authController.logIn(
                          _emailController.text.trim(),
                          _passwordController.text,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
