import 'dart:io';

import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onNotificationPressed;
  final VoidCallback onMenuPressed;
  final String? profileImageUrl;
  final bool isVerified;
  final String role;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onNotificationPressed,
    required this.onMenuPressed,
    this.profileImageUrl,
    required this.isVerified,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = userName.trim().isEmpty
        ? 'Donor'
        : userName.trim().split(RegExp(r'\s+')).first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFF3F5F7),
                child: _buildAvatar(profileImageUrl),
              ),
              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $displayName!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isVerified)
                    Row(
                      children: [
                        Text(
                          role == 'donor'
                              ? 'Verified Donor'
                              : 'Verified Volunteer',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                      ],
                    ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: onNotificationPressed,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: onMenuPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ImageProvider<Object>? _resolveProfileImage(String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) {
      return null;
    }
    final value = imagePath.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return NetworkImage(value);
    }
    final file = File(value);
    if (file.existsSync()) {
      return FileImage(file);
    }
    if (value.contains('/')) {
      final normalized = value.startsWith('/') ? value.substring(1) : value;
      return NetworkImage('${ApiEndpoints.mediaServerUrl}/$normalized');
    }
    return NetworkImage(ApiEndpoints.profilePicture(value));
  }

  Widget _buildAvatar(String? imagePath) {
    final provider = _resolveProfileImage(imagePath);
    if (provider == null) {
      return const Icon(Icons.person, size: 40, color: Colors.deepPurple);
    }

    return ClipOval(
      child: Image(
        image: provider,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, size: 40, color: Colors.deepPurple),
      ),
    );
  }
}
