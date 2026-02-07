import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/donor_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/repositories/donor_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateDonorProfileParams extends Equatable {
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String? profilePicture;

  const UpdateDonorProfileParams({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [userId, fullName, phoneNumber, profilePicture];
}

final updateDonorProfileUsecaseProvider = Provider<UpdateDonorProfileUsecase>((ref) {
  final repository = ref.read(authDonorRepositoryProvider);
  return UpdateDonorProfileUsecase(authDonorRepository: repository);
});

class UpdateDonorProfileUsecase
    implements UsecaseWithParams<bool, UpdateDonorProfileParams> {
  final IDonorAuthRepository _authDonorRepository;

  UpdateDonorProfileUsecase({required IDonorAuthRepository authDonorRepository})
      : _authDonorRepository = authDonorRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateDonorProfileParams params) async {
    final result = await _authDonorRepository.updateDonorProfile(
      params.userId,
      params.fullName,
      params.phoneNumber,
      params.profilePicture,
    );
    return result.map((_) => true);
  }
}
