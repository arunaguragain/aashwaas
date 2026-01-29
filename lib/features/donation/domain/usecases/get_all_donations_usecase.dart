import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/donation/data/repositories/donation_repository.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/domain/repositories/donation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllDonationsUsecaseProvider = Provider<GetAllDonationsUsecase>((ref) {
  final donationRepository = ref.read(donationRepositoryProvider);
  return GetAllDonationsUsecase(donationRepository: donationRepository);
});

class GetAllDonationsUsecase implements UsecaseWithoutParams<List<DonationEntity>> {
  final IDonationRepository _donationRepository;

  GetAllDonationsUsecase({required IDonationRepository donationRepository})
    : _donationRepository = donationRepository;

  @override
  Future<Either<Failure, List<DonationEntity>>> call() {
    return _donationRepository.getAllDonations();
  }
}
