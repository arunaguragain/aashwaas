import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/donation/data/repositories/donation_repository.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/domain/repositories/donation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetDonationsByUserParams extends Equatable {
  final String donorId;

  const GetDonationsByUserParams({required this.donorId});

  @override
  List<Object?> get props => [donorId];
}

final getDonationsByUserUsecaseProvider = Provider<GetDonationsByUserUsecase>((ref) {
  final donationRepository = ref.read(donationRepositoryProvider);
  return GetDonationsByUserUsecase(donationRepository: donationRepository);
});

class GetDonationsByUserUsecase implements UsecaseWithParams<List<DonationEntity>, GetDonationsByUserParams> {
  final IDonationRepository _donationRepository;

  GetDonationsByUserUsecase({required IDonationRepository donationRepository})
    : _donationRepository = donationRepository;

  @override
  Future<Either<Failure, List<DonationEntity>>> call(GetDonationsByUserParams params) {
    return _donationRepository.getItemsByUser(params.donorId);
  }
}
