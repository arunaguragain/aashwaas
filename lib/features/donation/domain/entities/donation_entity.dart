import 'package:equatable/equatable.dart';

class DonationEntity extends Equatable {
  final String? donationId;
  final String itemName;
  final String category;
  final String? description;
  final String quantity;
  final String condition;
  final String pickupLocation;
  final String? media;
  final String? donorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;

  const DonationEntity({
    this.donationId,
    required this.itemName,
    required this.category,
    this.description,
    required this.quantity,
    required this.condition,
    required this.pickupLocation,
    this.media,
    this.donorId,
    this.createdAt,
    this.status,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    donationId,
    itemName,
    category,
    description,
    quantity,
    condition,
    pickupLocation,
    media,
    donorId,
    createdAt,
    updatedAt,
    status,
  ];
}
