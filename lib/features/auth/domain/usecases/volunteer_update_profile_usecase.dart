import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/volunteer_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/repositories/volunteer_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateVolunteerProfileParams extends Equatable {
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String? profilePicture;

  const UpdateVolunteerProfileParams({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [userId, fullName, phoneNumber, profilePicture];
}

final updateVolunteerProfileUsecaseProvider = Provider<UpdateVolunteerProfileUsecase>((ref) {
  final repository = ref.read(authVolunteerRepositoryProvider);
  return UpdateVolunteerProfileUsecase(authVolunteerRepository: repository);
});

class UpdateVolunteerProfileUsecase
    implements UsecaseWithParams<bool, UpdateVolunteerProfileParams> {
  final IVolunteerAuthRepository _authVolunteerRepository;

  UpdateVolunteerProfileUsecase({
    required IVolunteerAuthRepository authVolunteerRepository,
  }) : _authVolunteerRepository = authVolunteerRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateVolunteerProfileParams params) async {
    final result = await _authVolunteerRepository.updateVolunteerProfile(
      params.userId,
      params.fullName,
      params.phoneNumber,
      params.profilePicture,
    );
    return result.map((_) => true);
  }
}
