import 'package:json_annotation/json_annotation.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';

part 'wishlist_api_model.g.dart';

String? _extractId(dynamic value) {
  if (value == null) return null;
  if (value is Map) return value['_id'] as String?;
  return value as String?;
}

WishlistStatus _statusFromString(String? status) {
  switch (status) {
    case 'fulfilled':
      return WishlistStatus.fulfilled;
    case 'cancelled':
      return WishlistStatus.cancelled;
    case 'active':
    default:
      return WishlistStatus.active;
  }
}

String _statusToString(WishlistStatus status) {
  switch (status) {
    case WishlistStatus.fulfilled:
      return 'fulfilled';
    case WishlistStatus.cancelled:
      return 'cancelled';
    case WishlistStatus.active:
      return 'active';
  }
}

@JsonSerializable()
class WishlistApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String category;
  final String plannedDate;
  final String? notes;
  @JsonKey(fromJson: _extractId)
  final String? donorId;
  @JsonKey(fromJson: _statusFromString, toJson: _statusToString)
  final WishlistStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WishlistApiModel({
    this.id,
    required this.title,
    required this.category,
    required this.plannedDate,
    this.notes,
    this.donorId,
    this.status = WishlistStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  factory WishlistApiModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$WishlistApiModelToJson(this);

  WishlistEntity toEntity() => WishlistEntity(
    wishlistId: id,
    title: title,
    category: category,
    plannedDate: plannedDate,
    notes: notes,
    donorId: donorId ?? '',
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory WishlistApiModel.fromEntity(WishlistEntity entity) =>
      WishlistApiModel(
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

  static List<WishlistEntity> toEntityList(List<WishlistApiModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
