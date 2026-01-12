import 'package:aashwaas/features/auth/data/models/volunteer_auth_api_model.dart';
import 'package:aashwaas/features/auth/data/models/volunteer_auth_hive_model.dart';

abstract interface class IVolunteerAuthLocalDataSource {
  Future<bool> registerVolunteer(VolunteerAuthHiveModel model);
  Future<VolunteerAuthHiveModel?> loginVolunteer(String email, String password);
  Future<VolunteerAuthHiveModel?> getCurrentVolunteer();
  Future<bool> logout();
  Future<bool> isEmailExistsV(String email);
  Future<VolunteerAuthHiveModel> getDonorById(String authId);
}

abstract interface class IVolunteerAuthRemoteDataSource{
  Future<VolunteerAuthApiModel> registerDonor(VolunteerAuthApiModel user);
  Future<VolunteerAuthApiModel?> loginDonor(String email, String password);
  Future<VolunteerAuthApiModel> getDonorById(String authId);
}