import 'package:aashwaas/core/services/hive/hive_service.dart';
import 'package:aashwaas/features/auth/data/datasources/volunteer_auth_datasource.dart';
import 'package:aashwaas/features/auth/data/models/volunteer_auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authLocalDatasourceProvider = Provider<VolunteerAuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return VolunteerAuthLocalDatasource(hiveService: hiveService);
});

class VolunteerAuthLocalDatasource implements IVolunteerAuthDataSource {
  final HiveService _hiveService;

  VolunteerAuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

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
}
