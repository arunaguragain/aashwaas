import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:equatable/equatable.dart';

enum WishlistViewStatus {
  initial,
  loading,
  loaded,
  error,
  created,
  updated,
  deleted,
}

class WishlistState extends Equatable {
  final WishlistViewStatus status;
  final List<WishlistEntity> wishlists;
  final List<WishlistEntity> myWishlists;
  final List<WishlistEntity> activeWishlists;
  final List<WishlistEntity> fulfilledWishlists;
  final WishlistEntity? selectedWishlist;
  final String? errorMessage;
  final int totalWishlistCount;

  const WishlistState({
    this.status = WishlistViewStatus.initial,
    this.wishlists = const [],
    this.myWishlists = const [],
    this.activeWishlists = const [],
    this.fulfilledWishlists = const [],
    this.selectedWishlist,
    this.errorMessage,
    this.totalWishlistCount = 0,
  });

  WishlistState copyWith({
    WishlistViewStatus? status,
    List<WishlistEntity>? wishlists,
    List<WishlistEntity>? myWishlists,
    List<WishlistEntity>? activeWishlists,
    List<WishlistEntity>? fulfilledWishlists,
    WishlistEntity? selectedWishlist,
    bool resetSelectedWishlist = false,
    String? errorMessage,
    bool resetErrorMessage = false,
    int? totalWishlistCount,
  }) {
    return WishlistState(
      status: status ?? this.status,
      wishlists: wishlists ?? this.wishlists,
      myWishlists: myWishlists ?? this.myWishlists,
      activeWishlists: activeWishlists ?? this.activeWishlists,
      fulfilledWishlists: fulfilledWishlists ?? this.fulfilledWishlists,
      selectedWishlist: resetSelectedWishlist
          ? null
          : (selectedWishlist ?? this.selectedWishlist),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      totalWishlistCount: totalWishlistCount ?? this.totalWishlistCount,
    );
  }

  @override
  List<Object?> get props => [
    status,
    wishlists,
    myWishlists,
    activeWishlists,
    fulfilledWishlists,
    selectedWishlist,
    errorMessage,
    totalWishlistCount,
  ];
}
