import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:aashwaas/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateWishlistParams extends Equatable {
  final String? wishlistId;
  final String title;
  final String category;
  final String plannedDate;
  final String? notes;
  final String donorId;
  final String? status;

  const UpdateWishlistParams({
    this.wishlistId,
    required this.title,
    required this.category,
    required this.plannedDate,
    this.notes,
    required this.donorId,
    this.status,
  });

  @override
  List<Object?> get props => [
    wishlistId,
    title,
    category,
    plannedDate,
    notes,
    donorId,
    status,
  ];
}

final updateWishlistUsecaseProvider = Provider<UpdateWishlistUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return UpdateWishlistUsecase(wishlistRepository: wishlistRepository);
});

class UpdateWishlistUsecase
    implements UsecaseWithParams<bool, UpdateWishlistParams> {
  final IWishlistRepository _wishlistRepository;

  UpdateWishlistUsecase({required IWishlistRepository wishlistRepository})
    : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateWishlistParams params) {
    final entity = WishlistEntity(
      wishlistId: params.wishlistId,
      title: params.title,
      category: params.category,
      plannedDate: params.plannedDate,
      notes: params.notes,
      donorId: params.donorId,
      status: params.status == null
          ? WishlistStatus.active
          : WishlistStatus.values.firstWhere(
              (e) => e.toString().split('.').last == params.status,
            ),
    );

    return _wishlistRepository.updateWishlist(entity);
  }
}
