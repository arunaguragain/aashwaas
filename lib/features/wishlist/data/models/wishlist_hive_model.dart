import 'package:hive/hive.dart';
import 'package:aashwaas/core/constants/hive_table_constant.dart';
import 'package:aashwaas/features/wishlist/data/models/wishlist_api_model.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';

part 'wishlist_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.wishlistTypeId)
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

  static List<WishlistEntity> toEntityList(List<WishlistHiveModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }

  /// Convert from API model to Hive model for caching
  factory WishlistHiveModel.fromApiModel(WishlistApiModel apiModel) {
    return WishlistHiveModel(
      id: apiModel.id,
      title: apiModel.title,
      category: apiModel.category,
      plannedDate: apiModel.plannedDate,
      notes: apiModel.notes,
      donorId: apiModel.donorId ?? '',
      status: apiModel.status,
      createdAt: apiModel.createdAt,
      updatedAt: apiModel.updatedAt,
    );
  }

  /// Convert list of API models to Hive models for caching
  static List<WishlistHiveModel> fromApiModelList(
    List<WishlistApiModel> apiModels,
  ) {
    return apiModels.map((m) => WishlistHiveModel.fromApiModel(m)).toList();
  }
}
