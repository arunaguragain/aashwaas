import 'package:flutter/material.dart';

class DonationPhotosSection extends StatefulWidget {
  const DonationPhotosSection({super.key});

  @override
  State<DonationPhotosSection> createState() => _DonationPhotosSectionState();
}

class _DonationPhotosSectionState extends State<DonationPhotosSection> {
  List<String> selectedPhotos = [];

  void _addPhoto() {
    setState(() {
      selectedPhotos.add('photo_${selectedPhotos.length + 1}');
    });
  }

  void _removePhoto(int index) {
    setState(() {
      selectedPhotos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add photos to help us verify the items',
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
        const SizedBox(height: 12),
        if (selectedPhotos.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 40,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 10),
                const Text(
                  'No photos added yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        if (selectedPhotos.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: selectedPhotos.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                    ),
                    child: Icon(Icons.image, color: Colors.grey[400]),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removePhoto(index),
                    ),
                  ),
                ],
              );
            },
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _addPhoto,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Add Photos'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
