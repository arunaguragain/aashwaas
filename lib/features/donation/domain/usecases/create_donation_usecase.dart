import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/donation/data/repositories/donation_repository.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/domain/repositories/donation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateDonationParams extends Equatable {
  final String itemName;
  final String category;
  final String? description;
  final String quantity;
  final String condition;
  final String pickupLocation;
  final String? media;
  final String? donorId;

  const CreateDonationParams({
    required this.itemName,
    required this.category,
    this.description,
    required this.quantity,
    required this.condition,
    required this.pickupLocation,
    this.media,
    this.donorId,
  });

  @override
  List<Object?> get props => [
    itemName,
    category,
    description,
    quantity,
    condition,
    pickupLocation,
    media,
    donorId,
  ];
}

final createDonationUsecaseProvider = Provider<CreateDonationUsecase>((ref) {
  final donationRepository = ref.read(donationRepositoryProvider);
  return CreateDonationUsecase(donationRepository: donationRepository);
});

class CreateDonationUsecase
    implements UsecaseWithParams<bool, CreateDonationParams> {
  final IDonationRepository _donationRepository;

  CreateDonationUsecase({required IDonationRepository donationRepository})
    : _donationRepository = donationRepository;

  @override
  Future<Either<Failure, bool>> call(CreateDonationParams params) {
    final donationEntity = DonationEntity(
      itemName: params.itemName,
      category: params.category,
      description: params.description,
      quantity: params.quantity,
      condition: params.condition,
      pickupLocation: params.pickupLocation,
      media: params.media,
      donorId: params.donorId,
    );

    return _donationRepository.createDonation(donationEntity);
  }
}
