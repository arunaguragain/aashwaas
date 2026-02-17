import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String? reviewId;
  final String userId;
  final double rating;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ReviewEntity({
    this.reviewId,
    required this.userId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    reviewId,
    userId,
    rating,
    comment,
    createdAt,
    updatedAt,
  ];
}
