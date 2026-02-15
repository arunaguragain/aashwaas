import 'package:aashwaas/features/wishlist/data/models/wishlist_api_model.dart';
import 'package:aashwaas/features/wishlist/data/models/wishlist_hive_model.dart';

abstract interface class IWishlistLocalDataSource {
  Future<List<WishlistHiveModel>> getAllWishlists();
  Future<void> cacheAllWishlists(List<WishlistHiveModel> wishlists);
  Future<List<WishlistHiveModel>> getWishlistsByDonor(String donorId);
  Future<List<WishlistHiveModel>> getWishlistsByCategory(String category);
  Future<List<WishlistHiveModel>> getWishlistsByStatus(String status);
  Future<WishlistHiveModel?> getWishlistById(String wishlistId);
  Future<bool> createWishlist(WishlistHiveModel wishlist);
  Future<bool> updateWishlist(WishlistHiveModel wishlist);
  Future<bool> deleteWishlist(String wishlistId);
}

abstract interface class IWishlistRemoteDataSource {
  Future<WishlistApiModel> createWishlist(WishlistApiModel wishlist);
  Future<List<WishlistApiModel>> getAllWishlists();
  Future<List<WishlistApiModel>> getWishlistsByDonor(String donorId);
  Future<WishlistApiModel> getWishlistById(String wishlistId);
  Future<List<WishlistApiModel>> getWishlistsByCategory(String category);
  Future<List<WishlistApiModel>> getWishlistsByStatus(String status);
  Future<bool> updateWishlist(WishlistApiModel wishlist);
  Future<bool> deleteWishlist(String wishlistId);
}
