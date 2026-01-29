import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/donation/data/repositories/donation_repository.dart';
import 'package:aashwaas/features/donation/domain/repositories/donation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteDonationParams extends Equatable {
  final String donationId;

  const DeleteDonationParams({required this.donationId});

  @override
  List<Object?> get props => [donationId];
}

final deleteDonationUsecaseProvider = Provider<DeleteDonationUsecase>((ref) {
  final donationRepository = ref.read(donationRepositoryProvider);
  return DeleteDonationUsecase(donationRepository: donationRepository);
});

class DeleteDonationUsecase implements UsecaseWithParams<bool, DeleteDonationParams> {
  final IDonationRepository _donationRepository;

  DeleteDonationUsecase({required IDonationRepository donationRepository})
    : _donationRepository = donationRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteDonationParams params) {
    return _donationRepository.deleteDonation(params.donationId);
  }
}
