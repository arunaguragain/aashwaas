import 'dart:io';

import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/profile_info_row.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.onEditPressed,
    required this.roleSinceText,
  });

  final String fullName;
  final String email;
  final String phone;
  final String? profileImage;
  final VoidCallback onEditPressed;
  final String roleSinceText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E8EF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: const Color(0xFFF3F5F7),
                backgroundImage: _resolveProfileImage(profileImage),
                child: profileImage == null || profileImage!.trim().isEmpty
                    ? const Icon(Icons.person, color: Colors.grey, size: 36)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7F7EE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Color(0xFF2EAD63),
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ProfileInfoRow(icon: Icons.mail_outline, text: email),
                    const SizedBox(height: 4),
                    ProfileInfoRow(icon: Icons.phone_outlined, text: phone),
                    const SizedBox(height: 6),
                    const ProfileInfoRow(
                      icon: Icons.location_on_outlined,
                      text: 'Boudha, Mahankal',
                    ),
                    const SizedBox(height: 4),
                    ProfileInfoRow(
                      icon: Icons.groups_outlined,
                      text: roleSinceText,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onEditPressed,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit Profile'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: const Color(0xFF2B3A55),
                side: const BorderSide(color: Color(0xFFD8DEE8)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
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
}
