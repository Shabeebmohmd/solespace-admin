import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Terms & Conditions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: ${DateTime.now().toString().split(' ')[0]}',
              style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using SoleSpace, you accept and agree to be bound by the terms and conditions of this agreement.',
            ),
            _buildSection(
              '2. Use License',
              'Permission is granted to temporarily access the materials (information or software) on SoleSpace\'s website for personal, non-commercial transitory viewing only.',
            ),
            _buildSection(
              '3. User Account',
              'To access certain features of the website, you must register for an account. You agree to provide accurate and complete information and to keep your account credentials secure.',
            ),
            _buildSection(
              '4. Product Information',
              'We strive to display accurate product information, including prices and availability. However, we do not guarantee the accuracy of such information.',
            ),
            _buildSection(
              '5. Ordering and Payment',
              'By placing an order, you warrant that you are legally capable of entering into binding contracts. All payments must be made in full before order processing.',
            ),
            _buildSection(
              '6. Shipping and Delivery',
              'Delivery times are estimates only. We are not responsible for delays beyond our control. Risk of loss and title for items purchased pass to you upon delivery.',
            ),
            _buildSection(
              '7. Returns and Refunds',
              'Our return policy allows returns within 30 days of delivery. Items must be unused and in original packaging. Refunds will be processed within 5-7 business days.',
            ),
            _buildSection(
              '8. Intellectual Property',
              'All content on this website, including text, graphics, logos, and software, is the property of SoleSpace and is protected by copyright laws.',
            ),
            _buildSection(
              '9. Limitation of Liability',
              'SoleSpace shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the service.',
            ),
            _buildSection(
              '10. Changes to Terms',
              'We reserve the right to modify these terms at any time. We will notify users of any material changes via email or website notice.',
            ),
            _buildSection(
              'Contact Information',
              'For any questions about these Terms and Conditions, please contact us at:\n\n'
                  'Email: support@solespace.com\n'
                  'Phone: +1 (555) 123-4567',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(content, style: Get.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
