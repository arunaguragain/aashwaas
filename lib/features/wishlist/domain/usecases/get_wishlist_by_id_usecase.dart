import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:aashwaas/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetWishlistByIdParams extends Equatable {
  final String wishlistId;

  const GetWishlistByIdParams({required this.wishlistId});

  @override
  List<Object?> get props => [wishlistId];
}

final getWishlistByIdUsecaseProvider =
    Provider<GetWishlistByIdUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return GetWishlistByIdUsecase(wishlistRepository: wishlistRepository);
});

class GetWishlistByIdUsecase implements UsecaseWithParams<WishlistEntity, GetWishlistByIdParams> {
  final IWishlistRepository _wishlistRepository;

  GetWishlistByIdUsecase({required IWishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, WishlistEntity>> call(GetWishlistByIdParams params) {
    return _wishlistRepository.getWishlistById(params.wishlistId);
  }
}
