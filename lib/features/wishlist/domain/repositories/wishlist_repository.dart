import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IWishlistRepository {
  Future<Either<Failure, List<WishlistEntity>>> getAllWishlists();
  Future<Either<Failure, List<WishlistEntity>>> getWishlistsByDonor(
    String donorId,
  );
  Future<Either<Failure, List<WishlistEntity>>> getWishlistsByCategory(
    String category,
  );
  Future<Either<Failure, List<WishlistEntity>>> getWishlistsByStatus(
    String status,
  );
  Future<Either<Failure, WishlistEntity>> getWishlistById(String wishlistId);
  Future<Either<Failure, bool>> createWishlist(WishlistEntity entity);
  Future<Either<Failure, bool>> updateWishlist(WishlistEntity entity);
  Future<Either<Failure, bool>> deleteWishlist(String wishlistId);
}
