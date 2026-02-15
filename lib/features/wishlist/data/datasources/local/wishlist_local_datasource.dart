import 'package:aashwaas/features/wishlist/data/datasources/wishlist_datasource.dart';
import 'package:aashwaas/features/wishlist/data/models/wishlist_hive_model.dart';
import 'package:aashwaas/core/services/hive/hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistLocalDatasourceProvider = Provider<WishlistLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return WishlistLocalDatasource(hiveService: hiveService);
});

class WishlistLocalDatasource implements IWishlistLocalDataSource {
  final HiveService _hiveService;

  WishlistLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> createWishlist(WishlistHiveModel wishlist) async {
    try {
      await _hiveService.createWishlist(wishlist);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteWishlist(String wishlistId) async {
    try {
      await _hiveService.deleteWishlist(wishlistId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<WishlistHiveModel>> getAllWishlists() async {
    try {
      return _hiveService.getAllWishlists();
    } catch (e) {
      return [];
    }
  }

  Future<void> cacheAllWishlists(List<WishlistHiveModel> wishlists) async {
    try {
      await _hiveService.cacheAllWishlists(wishlists);
    } catch (_) {}
  }

  @override
  Future<WishlistHiveModel?> getWishlistById(String wishlistId) async {
    try {
      return _hiveService.getWishlistById(wishlistId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<WishlistHiveModel>> getWishlistsByCategory(
    String category,
  ) async {
    try {
      return _hiveService.getWishlistsByCategory(category);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<WishlistHiveModel>> getWishlistsByDonor(String donorId) async {
    try {
      return _hiveService.getWishlistsByDonor(donorId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<WishlistHiveModel>> getWishlistsByStatus(String status) async {
    try {
      return _hiveService.getWishlistsByStatus(status);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateWishlist(WishlistHiveModel wishlist) async {
    try {
      await _hiveService.updateWishlist(wishlist);
      return true;
    } catch (e) {
      return false;
    }
  }
}
