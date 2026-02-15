import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';

class NgoImage extends StatelessWidget {
  final String? photo;
  final double width;
  final double height;

  const NgoImage({super.key, this.photo, this.width = 72, this.height = 72});

  @override
  Widget build(BuildContext context) {
    final resolved = _resolveImage(photo);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width,
        height: height,
        color: const Color(0xFFF1F4F9),
        child: resolved == null
          ? const Icon(Icons.apartment, color: Colors.grey, size: 30)
          : Image(
            image: resolved,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.apartment, color: Colors.grey, size: 30),
            ),
      ),
    );
  }

  ImageProvider<Object>? _resolveImage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final trimmed = value.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return NetworkImage(trimmed);
    }
    if (trimmed.contains('/')) {
      final normalized = trimmed.startsWith('/')
          ? trimmed.substring(1)
          : trimmed;
      return NetworkImage('${ApiEndpoints.mediaServerUrl}/$normalized');
    }
    return NetworkImage(ApiEndpoints.profilePicture(trimmed));
  }
}
