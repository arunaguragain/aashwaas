import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/wishlist/domain/usecases/create_wishlist_usecase.dart';
import 'package:aashwaas/features/wishlist/domain/usecases/delete_wishlist_usecase.dart';
import 'package:aashwaas/features/wishlist/domain/usecases/get_all_wishlists_usecase.dart';
import 'package:aashwaas/features/wishlist/domain/usecases/get_wishlist_by_id_usecase.dart';
import 'package:aashwaas/features/wishlist/domain/usecases/get_wishlists_by_donor_usecase.dart';
import 'package:aashwaas/features/wishlist/domain/usecases/get_wishlists_by_category_usecase.dart';
import 'package:aashwaas/features/wishlist/domain/usecases/get_wishlists_by_status_usecase.dart';
import 'package:aashwaas/features/wishlist/domain/usecases/update_wishlist_usecase.dart';
import 'package:aashwaas/features/wishlist/presentation/state/wishlist_state.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';

final wishlistViewModelProvider =
    NotifierProvider<WishlistViewModel, WishlistState>(WishlistViewModel.new);

class WishlistViewModel extends Notifier<WishlistState> {
  late final GetAllWishlistsUsecase _getAllWishlistsUsecase;
  late final GetWishlistByIdUsecase _getWishlistByIdUsecase;
  late final GetWishlistsByDonorUsecase _getWishlistsByDonorUsecase;
  late final GetWishlistsByCategoryUsecase _getWishlistsByCategoryUsecase;
  late final GetWishlistsByStatusUsecase _getWishlistsByStatusUsecase;
  late final CreateWishlistUsecase _createWishlistUsecase;
  late final UpdateWishlistUsecase _updateWishlistUsecase;
  late final DeleteWishlistUsecase _deleteWishlistUsecase;

  @override
  WishlistState build() {
    _getAllWishlistsUsecase = ref.read(getAllWishlistsUsecaseProvider);
    _getWishlistByIdUsecase = ref.read(getWishlistByIdUsecaseProvider);
    _getWishlistsByDonorUsecase = ref.read(getWishlistsByDonorUsecaseProvider);
    _getWishlistsByCategoryUsecase = ref.read(
      getWishlistsByCategoryUsecaseProvider,
    );
    _getWishlistsByStatusUsecase = ref.read(
      getWishlistsByStatusUsecaseProvider,
    );
    _createWishlistUsecase = ref.read(createWishlistUsecaseProvider);
    _updateWishlistUsecase = ref.read(updateWishlistUsecaseProvider);
    _deleteWishlistUsecase = ref.read(deleteWishlistUsecaseProvider);
    return const WishlistState();
  }

  Future<void> createWishlist({
    required String title,
    required String category,
    required String plannedDate,
    String? notes,
    required String donorId,
  }) async {
    state = state.copyWith(status: WishlistViewStatus.loading);

    final result = await _createWishlistUsecase(
      CreateWishlistParams(
        title: title,
        category: category,
        plannedDate: plannedDate,
        notes: notes,
        donorId: donorId,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistViewStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: WishlistViewStatus.created);
        getAllWishlists();
      },
    );
  }

  Future<void> getAllWishlists() async {
    state = state.copyWith(status: WishlistViewStatus.loading);

    final result = await _getAllWishlistsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistViewStatus.error,
        errorMessage: failure.message,
      ),
      (wishlists) {
        final active = wishlists
            .where((w) => w.status == WishlistStatus.active)
            .toList();
        final fulfilled = wishlists
            .where((w) => w.status == WishlistStatus.fulfilled)
            .toList();
        state = state.copyWith(
          status: WishlistViewStatus.loaded,
          wishlists: wishlists,
          activeWishlists: active,
          fulfilledWishlists: fulfilled,
          totalWishlistCount: wishlists.length,
        );
      },
    );
  }

  Future<void> getWishlistById(String wishlistId) async {
    state = state.copyWith(status: WishlistViewStatus.loading);

    final result = await _getWishlistByIdUsecase(
      GetWishlistByIdParams(wishlistId: wishlistId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistViewStatus.error,
        errorMessage: failure.message,
      ),
      (wishlist) => state = state.copyWith(
        status: WishlistViewStatus.loaded,
        selectedWishlist: wishlist,
      ),
    );
  }

  Future<void> getMyWishlists(String donorId) async {
    state = state.copyWith(status: WishlistViewStatus.loading);

    final result = await _getWishlistsByDonorUsecase(
      GetWishlistsByDonorParams(donorId: donorId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistViewStatus.error,
        errorMessage: failure.message,
      ),
      (wishlists) => state = state.copyWith(
        status: WishlistViewStatus.loaded,
        myWishlists: wishlists,
        totalWishlistCount: wishlists.length,
      ),
    );
  }

  Future<void> getWishlistsByCategory(String category) async {
    state = state.copyWith(status: WishlistViewStatus.loading);

    final result = await _getWishlistsByCategoryUsecase(
      GetWishlistsByCategoryParams(category: category),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistViewStatus.error,
        errorMessage: failure.message,
      ),
      (wishlists) => state = state.copyWith(
        status: WishlistViewStatus.loaded,
        wishlists: wishlists,
        totalWishlistCount: wishlists.length,
      ),
    );
  }

  Future<void> getWishlistsByStatus(String status) async {
    state = state.copyWith(status: WishlistViewStatus.loading);

    final result = await _getWishlistsByStatusUsecase(
      GetWishlistsByStatusParams(status: status),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistViewStatus.error,
        errorMessage: failure.message,
      ),
      (wishlists) => state = state.copyWith(
        status: WishlistViewStatus.loaded,
        wishlists: wishlists,
        totalWishlistCount: wishlists.length,
      ),
    );
  }

  Future<void> updateWishlist({
    String? wishlistId,
    required String title,
    required String category,
    required String plannedDate,
    String? notes,
    required String donorId,
    String? status,
  }) async {
    state = state.copyWith(status: WishlistViewStatus.loading);

    final result = await _updateWishlistUsecase(
      UpdateWishlistParams(
        wishlistId: wishlistId,
        title: title,
        category: category,
        plannedDate: plannedDate,
        notes: notes,
        donorId: donorId,
        status: status,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistViewStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: WishlistViewStatus.updated);
        getAllWishlists();
      },
    );
  }

  Future<void> deleteWishlist(String wishlistId) async {
    state = state.copyWith(status: WishlistViewStatus.loading);

    final result = await _deleteWishlistUsecase(
      DeleteWishlistParams(wishlistId: wishlistId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistViewStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: WishlistViewStatus.deleted);
        getAllWishlists();
      },
    );
  }

  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void clearSelectedWishlist() {
    state = state.copyWith(resetSelectedWishlist: true);
  }

  void clearWishlistState() {
    state = state.copyWith(
      status: WishlistViewStatus.initial,
      resetErrorMessage: true,
      resetSelectedWishlist: true,
    );
  }
}
