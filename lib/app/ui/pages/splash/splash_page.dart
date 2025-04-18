import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo here
            SvgPicture.asset('assets/images/logo.svg', width: 300, height: 300),
            const SizedBox(height: 20),
            Text(
              'Sole Space Admin',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.blueAccent, // Adjusted for visibility
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
