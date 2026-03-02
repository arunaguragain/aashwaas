import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IDonorAuthRepository {
  Future<Either<Failure, bool>> registerDonor(DonorAuthEntity entity);
  Future<Either<Failure, DonorAuthEntity>> loginDonor(
    String email,
    String password,
  );
  Future<Either<Failure, DonorAuthEntity>> getCurrentDonor();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, DonorAuthEntity>> updateDonorProfile(
    String userId,
    String fullName,
    String phoneNumber,
    String? profilePicture,
  );
  Future<Either<Failure, String>> uploadDonorProfilePhoto(
    String userId,
    String filePath,
  );
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, bool>> resetPassword(String token, String newPassword);
  Future<Either<Failure, void>> requestPasswordOtp(String email);
  Future<Either<Failure, bool>> resetPasswordWithOtp(
    String email,
    String otp,
    String newPassword,
  );
}
