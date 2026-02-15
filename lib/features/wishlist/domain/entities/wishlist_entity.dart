import 'package:equatable/equatable.dart';

enum WishlistStatus { active, fulfilled, cancelled }

class WishlistEntity extends Equatable {
  final String? wishlistId;
  final String title;
  final String category;
  final String plannedDate;
  final String? notes;
  final String donorId;
  final WishlistStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WishlistEntity({
    this.wishlistId,
    required this.title,
    required this.category,
    required this.plannedDate,
    this.notes,
    required this.donorId,
    this.status = WishlistStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    wishlistId,
    title,
    category,
    plannedDate,
    notes,
    donorId,
    status,
    createdAt,
    updatedAt,
  ];
}
