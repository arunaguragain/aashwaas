import 'package:aashwaas/core/constants/hive_table_constant.dart';
import 'package:aashwaas/features/auth/data/models/donor_auth_hive_model.dart';
import 'package:aashwaas/features/auth/data/models/volunteer_auth_hive_model.dart';
import 'package:aashwaas/features/donation/data/models/donatioin_hive_model.dart';
import 'package:aashwaas/features/wishlist/data/models/wishlist_hive_model.dart';
import 'package:aashwaas/features/task/data/models/task_hive_model.dart';
import 'package:aashwaas/features/review/data/models/review_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapter();
    await openBoxes();
  }

  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.donorAuthTypeId)) {
      Hive.registerAdapter(DonorAuthHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.volunteerAuthTypeId)) {
      Hive.registerAdapter(VolunteerAuthHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.donationTypeId)) {
      Hive.registerAdapter(DonationHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.wishlistTypeId)) {
      Hive.registerAdapter(WishlistHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.taskTypeId)) {
      Hive.registerAdapter(TaskHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.reviewTypeId)) {
      Hive.registerAdapter(ReviewHiveModelAdapter());
    }
  }

  Future<void> openBoxes() async {
    await Hive.openBox<DonorAuthHiveModel>(HiveTableConstant.donorAuthTable);
    await Hive.openBox<VolunteerAuthHiveModel>(
      HiveTableConstant.volunteerAuthTable,
    );
    await Hive.openBox<DonationHiveModel>(HiveTableConstant.donationTable);
    await Hive.openBox<WishlistHiveModel>(HiveTableConstant.wishlistTable);
    await Hive.openBox<TaskHiveModel>(HiveTableConstant.taskTable);
    await Hive.openBox<ReviewHiveModel>(HiveTableConstant.reviewTable);
  }

  Future<void> close() async {
    await Hive.close();
  }

  //queries of donor
  Box<DonorAuthHiveModel> get _donorAuthBox =>
      Hive.box<DonorAuthHiveModel>(HiveTableConstant.donorAuthTable);

  Future<DonorAuthHiveModel> registerDonor(DonorAuthHiveModel model) async {
    await _donorAuthBox.put(model.donorAuthId, model);
    return model;
  }

  //login
  Future<DonorAuthHiveModel?> loginDonor(String email, String password) async {
    final donors = _donorAuthBox.values.where(
      (donor) => donor.email == email && donor.password == password,
    );
    if (donors.isNotEmpty) {
      return donors.first;
    }
    return null;
  }

  //logout
  Future<void> logoutDonor() async {}

  //get current user
  DonorAuthHiveModel? getCurrentDonor(String donorAuthId) {
    return _donorAuthBox.get(donorAuthId);
  }

  //is Email exists
  bool isEmailExistsD(String email) {
    final donors = _donorAuthBox.values.where((donor) => donor.email == email);
    return donors.isNotEmpty;
  }

  //queries of volunteer
  Box<VolunteerAuthHiveModel> get _volunteerAuthBox =>
      Hive.box<VolunteerAuthHiveModel>(HiveTableConstant.volunteerAuthTable);

  Future<VolunteerAuthHiveModel> registerVolunteer(
    VolunteerAuthHiveModel model,
  ) async {
    await _volunteerAuthBox.put(model.volunteerAuthId, model);
    return model;
  }

  //login
  Future<VolunteerAuthHiveModel?> loginVolunteer(
    String email,
    String password,
  ) async {
    final volunteers = _volunteerAuthBox.values.where(
      (volunteer) => volunteer.email == email && volunteer.password == password,
    );
    if (volunteers.isNotEmpty) {
      return volunteers.first;
    }
    return null;
  }

  //logout
  Future<void> logoutVolunteer() async {}

  //get current user
  VolunteerAuthHiveModel? getCurrentVolunteer(String volunteerAuthId) {
    return _volunteerAuthBox.get(volunteerAuthId);
  }

  //is Email exists
  bool isEmailExistsV(String email) {
    final volunteers = _volunteerAuthBox.values.where(
      (volunteer) => volunteer.email == email,
    );
    return volunteers.isNotEmpty;
  }

  // Donation queries
  Box<DonationHiveModel> get _donationBox =>
      Hive.box<DonationHiveModel>(HiveTableConstant.donationTable);

  Box<WishlistHiveModel> get _wishlistBox =>
      Hive.box<WishlistHiveModel>(HiveTableConstant.wishlistTable);

  Future<bool> createDonation(DonationHiveModel donation) async {
    await _donationBox.put(donation.donationId, donation);
    return true;
  }

  Future<List<DonationHiveModel>> getAllDonations() async {
    return _donationBox.values.toList();
  }

  Future<DonationHiveModel?> getDonationById(String donationId) async {
    return _donationBox.get(donationId);
  }

  Future<List<DonationHiveModel>> getDonationsByCategory(
    String category,
  ) async {
    return _donationBox.values
        .where((donation) => donation.category == category)
        .toList();
  }

  Future<List<DonationHiveModel>> getDonationsByStatus(String status) async {
    return _donationBox.values
        .where((donation) => donation.status == status)
        .toList();
  }

  Future<List<DonationHiveModel>> getDonationsByDonor(String donorId) async {
    return _donationBox.values
        .where((donation) => donation.donorId == donorId)
        .toList();
  }

  Future<bool> updateDonation(DonationHiveModel donation) async {
    await _donationBox.put(donation.donationId, donation);
    return true;
  }

  Future<bool> deleteDonation(String donationId) async {
    try {
      // ignore: avoid_print
      print('HiveService.deleteDonation: deleting donation with id=$donationId');
    } catch (_) {}
    await _donationBox.delete(donationId);
    return true;
  }

  /// Cache all donations (clear existing and replace with new data)
  Future<void> cacheAllDonations(List<DonationHiveModel> donations) async {
    // Log cache operations so accidental clears can be traced in debug
    try {
      // ignore: avoid_print
      print('HiveService.cacheAllDonations: caching ${donations.length} donations (clearing existing)');
    } catch (_) {}
    await _donationBox.clear();
    for (var donation in donations) {
      await _donationBox.put(donation.donationId, donation);
    }
  }

  // Wishlist queries
  Future<bool> createWishlist(WishlistHiveModel wishlist) async {
    await _wishlistBox.put(wishlist.id, wishlist);
    return true;
  }

  Future<List<WishlistHiveModel>> getAllWishlists() async {
    return _wishlistBox.values.toList();
  }

  Future<WishlistHiveModel?> getWishlistById(String wishlistId) async {
    return _wishlistBox.get(wishlistId);
  }

  Future<List<WishlistHiveModel>> getWishlistsByCategory(
    String category,
  ) async {
    return _wishlistBox.values.where((w) => w.category == category).toList();
  }

  Future<List<WishlistHiveModel>> getWishlistsByStatus(String status) async {
    return _wishlistBox.values
        .where((w) => w.status.toString().split('.').last == status)
        .toList();
  }

  Future<List<WishlistHiveModel>> getWishlistsByDonor(String donorId) async {
    return _wishlistBox.values.where((w) => w.donorId == donorId).toList();
  }

  Future<bool> updateWishlist(WishlistHiveModel wishlist) async {
    await _wishlistBox.put(wishlist.id, wishlist);
    return true;
  }

  Future<bool> deleteWishlist(String wishlistId) async {
    await _wishlistBox.delete(wishlistId);
    return true;
  }

  /// Cache all wishlists (clear existing and replace with new data)
  Future<void> cacheAllWishlists(List<WishlistHiveModel> wishlists) async {
    await _wishlistBox.clear();
    for (var w in wishlists) {
      await _wishlistBox.put(w.id, w);
    }
  }

  //Review queries 
  Box<ReviewHiveModel> get _reviewBox =>
      Hive.box<ReviewHiveModel>(HiveTableConstant.reviewTable);

  Future<bool> createReview(ReviewHiveModel review) async {
    await _reviewBox.put(review.id, review);
    return true;
  }

  Future<List<ReviewHiveModel>> getAllReviews() async {
    return _reviewBox.values.toList();
  }

  Future<ReviewHiveModel?> getReviewById(String reviewId) async {
    return _reviewBox.get(reviewId);
  }

  Future<List<ReviewHiveModel>> getReviewsByUser(String userId) async {
    return _reviewBox.values.where((r) => r.userId == userId).toList();
  }

  Future<bool> updateReview(ReviewHiveModel review) async {
    await _reviewBox.put(review.id, review);
    return true;
  }

  Future<bool> deleteReview(String reviewId) async {
    await _reviewBox.delete(reviewId);
    return true;
  }

  /// Cache all reviews (clear existing and replace with new data)
  Future<void> cacheAllReviews(List<ReviewHiveModel> reviews) async {
    await _reviewBox.clear();
    for (var r in reviews) {
      await _reviewBox.put(r.id, r);
    }
  }
}
