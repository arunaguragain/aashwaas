import 'package:hive/hive.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';

part 'wishlist_hive_model.g.dart';

@HiveType(typeId: 2)
class WishlistHiveModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String category;

  @HiveField(3)
  String plannedDate;

  @HiveField(4)
  String? notes;

  @HiveField(5)
  String donorId;

  @HiveField(6)
  WishlistStatus status;

  @HiveField(7)
  DateTime? createdAt;

  @HiveField(8)
  DateTime? updatedAt;

  WishlistHiveModel({
    this.id,
    required this.title,
    required this.category,
    required this.plannedDate,
    this.notes,
    required this.donorId,
    this.status = WishlistStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  WishlistEntity toEntity() => WishlistEntity(
    wishlistId: id,
    title: title,
    category: category,
    plannedDate: plannedDate,
    notes: notes,
    donorId: donorId,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory WishlistHiveModel.fromEntity(WishlistEntity entity) =>
      WishlistHiveModel(
        id: entity.wishlistId,
        title: entity.title,
        category: entity.category,
        plannedDate: entity.plannedDate,
        notes: entity.notes,
        donorId: entity.donorId,
        status: WishlistStatus.values[entity.status.index],
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}
