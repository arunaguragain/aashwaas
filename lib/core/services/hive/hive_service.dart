import 'package:aashwaas/core/constants/hive_table_constant.dart';
import 'package:aashwaas/features/auth/data/models/donor_auth_hive_model.dart';
import 'package:aashwaas/features/auth/data/models/volunteer_auth_hive_model.dart';
import 'package:aashwaas/features/donation/data/models/donatioin_hive_model.dart';
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
  }

  Future<void> openBoxes() async {
    await Hive.openBox<DonorAuthHiveModel>(HiveTableConstant.donorAuthTable);
    await Hive.openBox<VolunteerAuthHiveModel>(
      HiveTableConstant.volunteerAuthTable,
    );
    await Hive.openBox<DonationHiveModel>(HiveTableConstant.donationTable);
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
    await _donationBox.delete(donationId);
    return true;
  }

  /// Cache all donations (clear existing and replace with new data)
  Future<void> cacheAllDonations(List<DonationHiveModel> donations) async {
    await _donationBox.clear();
    for (var donation in donations) {
      await _donationBox.put(donation.donationId, donation);
    }
  }

}
