import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
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
              'Information We Collect',
              'We collect information that you provide directly to us, including but not limited to:\n\n'
                  '• Personal information (name, email address, phone number)\n'
                  '• Account credentials\n'
                  '• Transaction information\n'
                  '• Device and usage information',
            ),
            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to:\n\n'
                  '• Provide and maintain our services\n'
                  '• Process your transactions\n'
                  '• Send you technical notices and support messages\n'
                  '• Communicate with you about products, services, and events\n'
                  '• Improve our services',
            ),
            _buildSection(
              'Information Sharing',
              'We do not sell or rent your personal information to third parties. We may share your information with:\n\n'
                  '• Service providers who assist in our operations\n'
                  '• Legal authorities when required by law\n'
                  '• Business partners with your consent',
            ),
            _buildSection(
              'Data Security',
              'We implement appropriate security measures to protect your personal information. However, no method of transmission over the Internet is 100% secure.',
            ),
            _buildSection(
              'Your Rights',
              'You have the right to:\n\n'
                  '• Access your personal information\n'
                  '• Correct inaccurate information\n'
                  '• Request deletion of your information\n'
                  '• Opt-out of marketing communications',
            ),
            _buildSection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at:\n\n'
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
