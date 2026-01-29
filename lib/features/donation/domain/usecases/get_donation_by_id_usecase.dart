import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/donation/data/repositories/donation_repository.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/domain/repositories/donation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetDonationByIdParams extends Equatable {
  final String donationId;

  const GetDonationByIdParams({required this.donationId});

  @override
  List<Object?> get props => [donationId];
}

final getDonationByIdUsecaseProvider = Provider<GetDonationByIdUsecase>((ref) {
  final donationRepository = ref.read(donationRepositoryProvider);
  return GetDonationByIdUsecase(donationRepository: donationRepository);
});

class GetDonationByIdUsecase implements UsecaseWithParams<DonationEntity, GetDonationByIdParams> {
  final IDonationRepository _donationRepository;

  GetDonationByIdUsecase({required IDonationRepository donationRepository})
    : _donationRepository = donationRepository;

  @override
  Future<Either<Failure, DonationEntity>> call(GetDonationByIdParams params) {
    return _donationRepository.getDonationById(params.donationId);
  }
}
