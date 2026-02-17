import 'package:hive/hive.dart';
import 'package:aashwaas/core/constants/hive_table_constant.dart';
import 'package:aashwaas/features/review/data/models/review_api_model.dart';
import 'package:aashwaas/features/review/domain/entities/review_entity.dart';

part 'review_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.reviewTypeId)
class ReviewHiveModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  double rating;

  @HiveField(2)
  String? comment;

  @HiveField(3)
  String userId;

  @HiveField(4)
  DateTime? createdAt;

  @HiveField(5)
  DateTime? updatedAt;

  ReviewHiveModel({
    this.id,
    required this.rating,
    this.comment,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  ReviewEntity toEntity() => ReviewEntity(
        reviewId: id,
        userId: userId,
        rating: rating,
        comment: comment,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory ReviewHiveModel.fromEntity(ReviewEntity entity) => ReviewHiveModel(
        id: entity.reviewId,
        rating: entity.rating,
        comment: entity.comment,
        userId: entity.userId,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  static List<ReviewEntity> toEntityList(List<ReviewHiveModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }

  factory ReviewHiveModel.fromApiModel(ReviewApiModel apiModel) {
    return ReviewHiveModel(
      id: apiModel.id,
      rating: apiModel.rating,
      comment: apiModel.comment,
      userId: apiModel.userId ?? '',
      createdAt: apiModel.createdAt,
      updatedAt: apiModel.updatedAt,
    );
  }

  static List<ReviewHiveModel> fromApiModelList(
    List<ReviewApiModel> apiModels,
  ) {
    return apiModels.map((m) => ReviewHiveModel.fromApiModel(m)).toList();
  }
}
