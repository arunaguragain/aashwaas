import 'package:aashwaas/features/auth/data/models/donor_auth_hive_model.dart';

abstract interface class IDonorAuthDataSource {
  Future<bool> registerDonor(DonorAuthHiveModel model);
  Future<DonorAuthHiveModel?> loginDonor(String email, String password);
  Future<DonorAuthHiveModel?> getCurrentDonor();
  Future<bool> logout();
  Future<bool> isEmailExistsD(String email);
}
