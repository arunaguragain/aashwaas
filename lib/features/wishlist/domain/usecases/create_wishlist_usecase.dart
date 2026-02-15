import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:aashwaas/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateWishlistParams extends Equatable {
  final String title;
  final String category;
  final String plannedDate;
  final String? notes;
  final String donorId;

  const CreateWishlistParams({
    required this.title,
    required this.category,
    required this.plannedDate,
    this.notes,
    required this.donorId,
  });

  @override
  List<Object?> get props => [title, category, plannedDate, notes, donorId];
}

final createWishlistUsecaseProvider = Provider<CreateWishlistUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return CreateWishlistUsecase(wishlistRepository: wishlistRepository);
});

class CreateWishlistUsecase
    implements UsecaseWithParams<bool, CreateWishlistParams> {
  final IWishlistRepository _wishlistRepository;

  CreateWishlistUsecase({required IWishlistRepository wishlistRepository})
    : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, bool>> call(CreateWishlistParams params) {
    final entity = WishlistEntity(
      title: params.title,
      category: params.category,
      plannedDate: params.plannedDate,
      notes: params.notes,
      donorId: params.donorId,
    );

    return _wishlistRepository.createWishlist(entity);
  }
}
