import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:aashwaas/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteWishlistParams extends Equatable {
  final String wishlistId;

  const DeleteWishlistParams({required this.wishlistId});

  @override
  List<Object?> get props => [wishlistId];
}

final deleteWishlistUsecaseProvider = Provider<DeleteWishlistUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return DeleteWishlistUsecase(wishlistRepository: wishlistRepository);
});

class DeleteWishlistUsecase
    implements UsecaseWithParams<bool, DeleteWishlistParams> {
  final IWishlistRepository _wishlistRepository;

  DeleteWishlistUsecase({required IWishlistRepository wishlistRepository})
    : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteWishlistParams params) {
    return _wishlistRepository.deleteWishlist(params.wishlistId);
  }
}
