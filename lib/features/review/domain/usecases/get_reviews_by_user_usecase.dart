import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/review/data/repositories/review_repository.dart';
import 'package:aashwaas/features/review/domain/entities/review_entity.dart';
import 'package:aashwaas/features/review/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetReviewsByUserParams extends Equatable {
  final String userId;

  const GetReviewsByUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getReviewsByUserUsecaseProvider = Provider<GetReviewsByUserUsecase>((
  ref,
) {
  final reviewRepository = ref.read(reviewRepositoryProvider);
  return GetReviewsByUserUsecase(reviewRepository: reviewRepository);
});

class GetReviewsByUserUsecase
    implements UsecaseWithParams<List<ReviewEntity>, GetReviewsByUserParams> {
  final IReviewRepository _reviewRepository;

  GetReviewsByUserUsecase({required IReviewRepository reviewRepository})
    : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, List<ReviewEntity>>> call(
    GetReviewsByUserParams params,
  ) {
    return _reviewRepository.getReviewsByUser(params.userId);
  }
}
