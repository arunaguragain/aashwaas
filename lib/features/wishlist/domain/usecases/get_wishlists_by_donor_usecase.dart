import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:aashwaas/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetWishlistsByDonorParams extends Equatable {
  final String donorId;

  const GetWishlistsByDonorParams({required this.donorId});

  @override
  List<Object?> get props => [donorId];
}

final getWishlistsByDonorUsecaseProvider = Provider<GetWishlistsByDonorUsecase>(
  (ref) {
    final wishlistRepository = ref.read(wishlistRepositoryProvider);
    return GetWishlistsByDonorUsecase(wishlistRepository: wishlistRepository);
  },
);

class GetWishlistsByDonorUsecase
    implements
        UsecaseWithParams<List<WishlistEntity>, GetWishlistsByDonorParams> {
  final IWishlistRepository _wishlistRepository;

  GetWishlistsByDonorUsecase({required IWishlistRepository wishlistRepository})
    : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, List<WishlistEntity>>> call(
    GetWishlistsByDonorParams params,
  ) {
    return _wishlistRepository.getWishlistsByDonor(params.donorId);
  }
}
