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
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Password',
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
                  ),
                  // TextFormField(
                  //   controller: _passwordController,
                  //   decoration: InputDecoration(
                  //     labelText: 'Password',
                  //     prefixIcon: const Icon(Icons.lock),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  //   obscureText: true,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter your password';
                  //     }
                  //     if (value.length < 6) {
                  //       return 'Password must be at least 6 characters';
                  //     }
                  //     return null;
                  //   },
                  // ),
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
                  // Obx(
                  //   () => ElevatedButton(
                  //     onPressed:
                  //         _authController.isLoading.value
                  //             ? null
                  //             : () {
                  //               if (_formKey.currentState!.validate()) {
                  //                 _authController.signIn(
                  //                   _emailController.text.trim(),
                  //                   _passwordController.text,
                  //                 );
                  //               }
                  //             },
                  //     style: ElevatedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(vertical: 16),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //     ),
                  //     child:
                  //         _authController.isLoading.value
                  //             ? const SizedBox(
                  //               height: 20,
                  //               width: 20,
                  //               child: CircularProgressIndicator(
                  //                 strokeWidth: 2,
                  //                 valueColor: AlwaysStoppedAnimation(
                  //                   Colors.white,
                  //                 ),
                  //               ),
                  //             )
                  //             : const Text(
                  //               'Login',
                  //               style: TextStyle(
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.bold,
                  //                 color: AppColors.white,
                  //               ),
                  //             ),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // Obx(
                  //   () =>
                  //       _authController.errorMessage.isNotEmpty
                  //           ? Text(
                  //             _authController.errorMessage.value,
                  //             style: const TextStyle(
                  //               color: Colors.red,
                  //               fontSize: 14,
                  //             ),
                  //             textAlign: TextAlign.center,
                  //           )
                  //           : const SizedBox.shrink(),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
