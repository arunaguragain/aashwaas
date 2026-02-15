import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:aashwaas/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetWishlistsByCategoryParams extends Equatable {
  final String category;

  const GetWishlistsByCategoryParams({required this.category});

  @override
  List<Object?> get props => [category];
}

final getWishlistsByCategoryUsecaseProvider =
    Provider<GetWishlistsByCategoryUsecase>((ref) {
      final wishlistRepository = ref.read(wishlistRepositoryProvider);
      return GetWishlistsByCategoryUsecase(
        wishlistRepository: wishlistRepository,
      );
    });

class GetWishlistsByCategoryUsecase
    implements
        UsecaseWithParams<List<WishlistEntity>, GetWishlistsByCategoryParams> {
  final IWishlistRepository _wishlistRepository;

  GetWishlistsByCategoryUsecase({
    required IWishlistRepository wishlistRepository,
  }) : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, List<WishlistEntity>>> call(
    GetWishlistsByCategoryParams params,
  ) {
    return _wishlistRepository.getWishlistsByCategory(params.category);
  }
}
