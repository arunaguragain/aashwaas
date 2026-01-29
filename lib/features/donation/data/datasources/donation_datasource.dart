import 'dart:io';

import 'package:aashwaas/features/donation/data/models/donation_api_model.dart';
import 'package:aashwaas/features/donation/data/models/donatioin_hive_model.dart';

abstract interface class IDonationLocalDataSource {
  Future<List<DonationHiveModel>> getAllDonations();
  Future<List<DonationHiveModel>> getDonationsByDonor(String donorId);
  Future<List<DonationHiveModel>> getDonationsByCategory(String category);
  Future<List<DonationHiveModel>> getDonationsByStatus(String status);
  Future<DonationHiveModel?> getDonationById(String donationId);
  Future<bool> createDonation(DonationHiveModel donation);
  Future<bool> updateDonation(DonationHiveModel donation);
  Future<bool> deleteDonation(String donationId);
}

abstract interface class IDonationRemoteDataSource {
  Future<String> uploadPhoto(File photo);
  Future<DonationApiModel> createDonation(DonationApiModel donation);
  Future<List<DonationApiModel>> getAllDonations();
  Future<List<DonationApiModel>> getDonationsByDonor(String donorId);
  Future<DonationApiModel> getDonationById(String donationId);
  Future<List<DonationApiModel>> getDonationsByCategory(String category);
  Future<List<DonationApiModel>> getDonationsByStatus(String status);
  Future<bool> updateDonation(DonationApiModel donation);
  Future<bool> deleteDonation(String donationId);
}
