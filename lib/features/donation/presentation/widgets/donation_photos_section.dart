import 'dart:io';
import 'package:flutter/material.dart';

class DonationPhotosSection extends StatelessWidget {
  final List<File> selectedMedia;
  final String? existingMediaUrl;
  final VoidCallback onAddPhoto;
  final VoidCallback onRemovePhoto;

  const DonationPhotosSection({
    super.key,
    required this.selectedMedia,
    this.existingMediaUrl,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final hintColor = theme.textTheme.bodySmall?.color ?? Colors.grey[700];
    final borderColor = theme.dividerColor;
    final fillColor = theme.inputDecorationTheme.fillColor ?? Colors.grey[100];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add photos to help us verify the items',
          style: TextStyle(fontSize: 12, color: hintColor),
        ),
        const SizedBox(height: 12),
        if (selectedMedia.isEmpty)
          (existingMediaUrl == null)
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(8),
                    color: fillColor,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: hintColor,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No photos added yet',
                        style: TextStyle(color: hintColor),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          existingMediaUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) {
                            return Center(
                              child: Icon(Icons.broken_image, color: hintColor),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: onRemovePhoto,
                      ),
                    ),
                  ],
                ),
        if (selectedMedia.isNotEmpty)
          Stack(
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(selectedMedia.first, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: -8,
                right: -8,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: onRemovePhoto,
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onAddPhoto,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Add Photos'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: borderColor),
            ),
          ),
        ),
      ],
    );
  }
}
