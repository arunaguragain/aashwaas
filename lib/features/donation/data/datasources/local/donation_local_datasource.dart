import 'package:aashwaas/core/services/hive/hive_service.dart';
import 'package:aashwaas/features/donation/data/datasources/donation_datasource.dart';
import 'package:aashwaas/features/donation/data/models/donatioin_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final donationLocalDatasourceProvider = Provider<DonationLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return DonationLocalDatasource(hiveService: hiveService);
});

class DonationLocalDatasource implements IDonationLocalDataSource {
  final HiveService _hiveService;

  DonationLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> createDonation(DonationHiveModel donation) async {
    try {
      await _hiveService.createDonation(donation);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> deleteDonation(String donationId) async {
    try {
      await _hiveService.deleteDonation(donationId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<DonationHiveModel>> getAllDonations() async {
    try {
      return _hiveService.getAllDonations();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<DonationHiveModel?> getDonationById(String donationId) async {
    try {
      return _hiveService.getDonationById(donationId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<DonationHiveModel>> getDonationsByCategory(
    String category,
  ) async {
    try {
      return _hiveService.getDonationsByCategory(category);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<DonationHiveModel>> getDonationsByDonor(String donorId) async {
    try {
      return _hiveService.getDonationsByDonor(donorId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<DonationHiveModel>> getDonationsByStatus(String status) async {
    try {
      return _hiveService.getDonationsByStatus(status);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateDonation(DonationHiveModel donation) async {
    try {
      await _hiveService.updateDonation(donation);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Cache all donations from API response
  Future<void> cacheAllDonations(List<DonationHiveModel> donations) async {
    await _hiveService.cacheAllDonations(donations);
  }
}
