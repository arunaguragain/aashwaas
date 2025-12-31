import 'package:aashwaas/features/auth/data/models/volunteer_auth_hive_model.dart';

abstract interface class IVolunteerAuthDataSource {
  Future<bool> registerVolunteer(VolunteerAuthHiveModel model);
  Future<VolunteerAuthHiveModel?> loginVolunteer(String email, String password);
  Future<VolunteerAuthHiveModel?> getCurrentVolunteer();
  Future<bool> logout();
  Future<bool> isEmailExistsV(String email);
}
