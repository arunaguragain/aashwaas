import 'package:flutter/material.dart';

class SettingsInfoPage extends StatelessWidget {
  const SettingsInfoPage({super.key, required this.title, required this.body});

  const SettingsInfoPage.terms({super.key})
      : title = 'Terms & Conditions',
        body = _termsAndConditions;

  const SettingsInfoPage.privacy({super.key})
      : title = 'Privacy Policy',
        body = _privacyPolicy;

  const SettingsInfoPage.about({super.key})
      : title = 'About',
        body = _about;

  final String title;
  final String body;

  static const String _termsAndConditions = '''By using Aashwaas, you agree to use the app in a lawful and respectful way. You are responsible for the accuracy of the information you provide, including profile details, contact information, and donation or volunteer activity.

Aashwaas connects donors and volunteers to coordinate help. We do not guarantee the availability, quality, or outcomes of any donation or volunteer activity. Interactions are between users and organizations, and you agree to exercise good judgment and follow local laws.

We may update features or these terms to improve the service or comply with policy changes. If we make material changes, we will update this page. Continued use of the app after changes means you accept the updated terms.''';

  static const String _privacyPolicy = '''We collect basic account details such as name, email, phone number, and role to create your profile and provide app features. We also collect limited usage data, like app interactions, to help improve performance and reliability.

Your information is used to support core features such as login, profile management, and connecting donors and volunteers. We do not sell your personal information. We may share data with service providers only as needed to run the app securely.

You can update your profile information at any time. If you have questions or requests about your data, please contact the Aashwaas support team.''';

  static const String _about = '''Aashwaas is a community-driven platform that connects donors and volunteers to make giving simple, transparent, and impactful.

Our goal is to reduce friction between people who want to help and organizations that need support. From donations to volunteer tasks, the app helps coordinate efforts with clarity and care.

Thank you for being part of the Aashwaas community and helping make a difference.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          body,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }
}
