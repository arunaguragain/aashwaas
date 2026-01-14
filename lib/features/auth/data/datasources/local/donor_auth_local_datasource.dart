import 'package:aashwaas/core/services/hive/hive_service.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/auth/data/datasources/donor_auth_datasource.dart';
import 'package:aashwaas/features/auth/data/models/donor_auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDonorLocalDatasourceProvider = Provider<DonorAuthLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return DonorAuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class DonorAuthLocalDatasource implements IDonorAuthLocalDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  DonorAuthLocalDatasource({
    required HiveService hiveService,
    required userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<DonorAuthHiveModel?> getCurrentDonor() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<bool> isEmailExistsD(String email) {
    try {
      final exists = _hiveService.isEmailExistsD(email);
      return Future.value(exists);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<DonorAuthHiveModel?> loginDonor(String email, String password) async {
    try {
      final donor = await _hiveService.loginDonor(email, password);
      if (donor != null) {
        await _userSessionService.saveUserSession(
          userId: donor.donorAuthId!,
          email: email,
          fullName: donor.fullName,
          phoneNumber: donor.phoneNumber,
          profileImage: donor.profilePicture ?? '', 
          role: 'donor',
        );
        await _userSessionService.setUserRole('donor');
      }
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
  
  @override
  Future<DonorAuthHiveModel> getDonorById(String authId) {
    // TODO: implement getDonorById
    throw UnimplementedError();
  }
  
  @override
  Future<DonorAuthHiveModel?> getDonorByEmail(String email) {
    // TODO: implement getDonorByEmail
    throw UnimplementedError();
  }
}
