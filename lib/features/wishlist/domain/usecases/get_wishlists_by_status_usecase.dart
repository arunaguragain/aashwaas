import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:aashwaas/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetWishlistsByStatusParams extends Equatable {
  final String status;

  const GetWishlistsByStatusParams({required this.status});

  @override
  List<Object?> get props => [status];
}

final getWishlistsByStatusUsecaseProvider =
    Provider<GetWishlistsByStatusUsecase>((ref) {
      final wishlistRepository = ref.read(wishlistRepositoryProvider);
      return GetWishlistsByStatusUsecase(
        wishlistRepository: wishlistRepository,
      );
    });

class GetWishlistsByStatusUsecase
    implements
        UsecaseWithParams<List<WishlistEntity>, GetWishlistsByStatusParams> {
  final IWishlistRepository _wishlistRepository;

  GetWishlistsByStatusUsecase({required IWishlistRepository wishlistRepository})
    : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, List<WishlistEntity>>> call(
    GetWishlistsByStatusParams params,
  ) {
    return _wishlistRepository.getWishlistsByStatus(params.status);
  }
}
