import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sole_space_admin/utils/utils.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add your logo here
              SvgPicture.asset(
                'assets/images/logo.svg',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20),
              Text(
                'Sole Space Admin',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              largeSpacing,
              LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                // backgroundColor: Theme.of(context).colorScheme.,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
