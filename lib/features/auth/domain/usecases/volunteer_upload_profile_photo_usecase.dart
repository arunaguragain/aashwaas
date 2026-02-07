import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/volunteer_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/repositories/volunteer_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadVolunteerProfilePhotoParams extends Equatable {
  final String userId;
  final String filePath;

  const UploadVolunteerProfilePhotoParams({
    required this.userId,
    required this.filePath,
  });

  @override
  List<Object?> get props => [userId, filePath];
}

final uploadVolunteerProfilePhotoUsecaseProvider = Provider<UploadVolunteerProfilePhotoUsecase>((ref) {
  final repository = ref.read(authVolunteerRepositoryProvider);
  return UploadVolunteerProfilePhotoUsecase(authVolunteerRepository: repository);
});

class UploadVolunteerProfilePhotoUsecase
    implements UsecaseWithParams<String, UploadVolunteerProfilePhotoParams> {
  final IVolunteerAuthRepository _authVolunteerRepository;

  UploadVolunteerProfilePhotoUsecase({
    required IVolunteerAuthRepository authVolunteerRepository,
  }) : _authVolunteerRepository = authVolunteerRepository;

  @override
  Future<Either<Failure, String>> call(
    UploadVolunteerProfilePhotoParams params,
  ) {
    return _authVolunteerRepository.uploadVolunteerProfilePhoto(
      params.userId,
      params.filePath,
    );
  }
}
