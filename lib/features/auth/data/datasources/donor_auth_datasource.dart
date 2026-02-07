import 'package:aashwaas/features/auth/data/models/donor_auth_api_model.dart';
import 'package:aashwaas/features/auth/data/models/donor_auth_hive_model.dart';

abstract interface class IDonorAuthLocalDataSource {
  Future<bool> registerDonor(DonorAuthHiveModel model);
  Future<DonorAuthHiveModel?> loginDonor(String email, String password);
  Future<DonorAuthHiveModel?> getCurrentDonor();
  Future<bool> logout();
  Future<bool> isEmailExistsD(String email);
  Future<DonorAuthHiveModel> getDonorById(String authId);
  Future<DonorAuthHiveModel?> getDonorByEmail(String email);
}

abstract interface class IDonorAuthRemoteDataSource{
  Future<DonorAuthApiModel> registerDonor(DonorAuthApiModel donor);
  Future<DonorAuthApiModel?> loginDonor(String email, String password);
  Future<DonorAuthApiModel> getDonorById(String authId);
  Future<DonorAuthApiModel> updateDonorProfile(
    String authId,
    Map<String, dynamic> payload,
  );
  Future<String> uploadDonorPhoto(String authId, String filePath);
}