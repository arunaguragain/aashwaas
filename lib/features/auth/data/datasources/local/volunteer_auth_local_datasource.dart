import 'package:aashwaas/core/services/hive/hive_service.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/auth/data/datasources/volunteer_auth_datasource.dart';
import 'package:aashwaas/features/auth/data/models/volunteer_auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authVolunteerLocalDatasourceProvider = Provider<VolunteerAuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return VolunteerAuthLocalDatasource(
    hiveService: hiveService, 
    userSessionService: userSessionService,
  );
});

class VolunteerAuthLocalDatasource implements IVolunteerAuthLocalDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  VolunteerAuthLocalDatasource({required HiveService hiveService, required userSessionService,})
    : _hiveService = hiveService,
    _userSessionService = userSessionService;

  @override
  Future<VolunteerAuthHiveModel?> getCurrentVolunteer() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<bool> isEmailExistsV(String email) {
    try{
      final exists=  _hiveService.isEmailExistsV(email);
      return Future.value(exists);
    }catch(e){
      return Future.value(false);
    }
  }

  @override
  Future<VolunteerAuthHiveModel?> loginVolunteer(String email, String password) async {
    try {
      final volunteer = await _hiveService.loginVolunteer(email, password);
      if (volunteer != null) {
        await _userSessionService.saveUserSession(
        userId: volunteer.volunteerAuthId!,
          email: email,
          fullName: volunteer.fullName,
          phoneNumber: volunteer.phoneNumber,
          profileImage: volunteer.profilePicture ?? '', 
          role: 'volunteer',
        );
        await _userSessionService.setUserRole('volunteer');
      }
      return Future.value(volunteer);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _hiveService.logoutVolunteer();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> registerVolunteer(VolunteerAuthHiveModel model) async {
    try {
      await _hiveService.registerVolunteer(model);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
  
  @override
  Future<VolunteerAuthHiveModel> getDonorById(String authId) {
    // TODO: implement getDonorById
    throw UnimplementedError();
  }
  
  @override
  Future<VolunteerAuthHiveModel?> getVolunteerByEmail(String email) {
    // TODO: implement getVolunteerByEmail
    throw UnimplementedError();
  }
  
  @override
  Future<VolunteerAuthHiveModel> getVolunteerById(String authId) {
    // TODO: implement getVolunteerById
    throw UnimplementedError();
  }
}
