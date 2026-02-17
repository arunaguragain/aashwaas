import 'package:json_annotation/json_annotation.dart';
import 'package:aashwaas/features/review/domain/entities/review_entity.dart';

part 'review_api_model.g.dart';

String? _extractId(dynamic value) {
  if (value == null) return null;
  if (value is Map) return value['_id'] as String?;
  return value as String?;
}

String? _extractUserName(dynamic value) {
  if (value == null) return null;
  if (value is Map) return (value['fullName'] ?? value['name']) as String?;
  return null;
}

@JsonSerializable()
class ReviewApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final double rating;
  final String? comment;
  @JsonKey(fromJson: _extractId)
  final String? userId;
  @JsonKey(fromJson: _extractUserName, name: 'userId')
  final String? authorName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReviewApiModel({
    this.id,
    required this.rating,
    this.comment,
    this.userId,
    this.authorName,
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewApiModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewApiModelToJson(this);

  ReviewEntity toEntity() => ReviewEntity(
    reviewId: id,
    userId: userId ?? '',
    authorName: authorName,
    rating: rating,
    comment: comment,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory ReviewApiModel.fromEntity(ReviewEntity entity) => ReviewApiModel(
    id: entity.reviewId,
    userId: entity.userId,
    authorName: entity.authorName,
    rating: entity.rating,
    comment: entity.comment,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );

  static List<ReviewEntity> toEntityList(List<ReviewApiModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
