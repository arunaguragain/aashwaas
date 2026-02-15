import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:aashwaas/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllWishlistsUsecaseProvider =
    Provider<GetAllWishlistsUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return GetAllWishlistsUsecase(wishlistRepository: wishlistRepository);
});

class GetAllWishlistsUsecase implements UsecaseWithoutParams<List<WishlistEntity>> {
  final IWishlistRepository _wishlistRepository;

  GetAllWishlistsUsecase({required IWishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, List<WishlistEntity>>> call() {
    return _wishlistRepository.getAllWishlists();
  }
}
