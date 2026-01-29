import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/donation/data/repositories/donation_repository.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/domain/repositories/donation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateDonationParams extends Equatable {
  final String donationId;
  final String itemName;
  final String category;
  final String? description;
  final String quantity;
  final String condition;
  final String pickupLocation;
  final String? media;
  final String? donorId;
  final String? status;

  const UpdateDonationParams({
    required this.donationId,
    required this.itemName,
    required this.category,
    this.description,
    required this.quantity,
    required this.condition,
    required this.pickupLocation,
    this.media,
    this.donorId,
    this.status,
  });

  @override
  List<Object?> get props => [
    donationId,
    itemName,
    category,
    description,
    quantity,
    condition,
    pickupLocation,
    media,
    donorId,
    status,
  ];
}

final updateDonationUsecaseProvider = Provider<UpdateDonationUsecase>((ref) {
  final donationRepository = ref.read(donationRepositoryProvider);
  return UpdateDonationUsecase(donationRepository: donationRepository);
});

class UpdateDonationUsecase implements UsecaseWithParams<bool, UpdateDonationParams> {
  final IDonationRepository _donationRepository;

  UpdateDonationUsecase({required IDonationRepository donationRepository})
    : _donationRepository = donationRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateDonationParams params) {
    final donationEntity = DonationEntity(
      donationId: params.donationId,
      itemName: params.itemName,
      category: params.category,
      description: params.description,
      quantity: params.quantity,
      condition: params.condition,
      pickupLocation: params.pickupLocation,
      media: params.media,
      donorId: params.donorId,
      status: params.status,
    );

    return _donationRepository.updateDonation(donationEntity);
  }
}
