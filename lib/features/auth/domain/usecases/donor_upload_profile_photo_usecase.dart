import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/donor_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/repositories/donor_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadDonorProfilePhotoParams extends Equatable {
  final String userId;
  final String filePath;

  const UploadDonorProfilePhotoParams({
    required this.userId,
    required this.filePath,
  });

  @override
  List<Object?> get props => [userId, filePath];
}

final uploadDonorProfilePhotoUsecaseProvider = Provider<UploadDonorProfilePhotoUsecase>((ref) {
  final repository = ref.read(authDonorRepositoryProvider);
  return UploadDonorProfilePhotoUsecase(authDonorRepository: repository);
});

class UploadDonorProfilePhotoUsecase
    implements UsecaseWithParams<String, UploadDonorProfilePhotoParams> {
  final IDonorAuthRepository _authDonorRepository;

  UploadDonorProfilePhotoUsecase({
    required IDonorAuthRepository authDonorRepository,
  }) : _authDonorRepository = authDonorRepository;

  @override
  Future<Either<Failure, String>> call(
    UploadDonorProfilePhotoParams params,
  ) {
    return _authDonorRepository.uploadDonorProfilePhoto(
      params.userId,
      params.filePath,
    );
  }
}
