import 'package:aashwaas/core/services/hive/hive_service.dart';
import 'package:aashwaas/features/auth/data/datasources/donor_auth_datasource.dart';
import 'package:aashwaas/features/auth/data/models/donor_auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDonorLocalDatasourceProvider = Provider<DonorAuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return DonorAuthLocalDatasource(hiveService: hiveService);
});

class DonorAuthLocalDatasource implements IDonorAuthDataSource {
  final HiveService _hiveService;

  DonorAuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<DonorAuthHiveModel?> getCurrentDonor() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<bool> isEmailExistsD(String email) {
    try{
      final exists=  _hiveService.isEmailExistsD(email);
      return Future.value(exists);
    }catch(e){
      return Future.value(false);
    }
  }

  @override
  Future<DonorAuthHiveModel?> loginDonor(String email, String password) async {
    try {
      final donor = await _hiveService.loginDonor(email, password);
      return Future.value(donor);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _hiveService.logoutDonor();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> registerDonor(DonorAuthHiveModel model) async {
    try {
      await _hiveService.registerDonor(model);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
