import 'dart:io';

import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/donation/data/repositories/donation_repository.dart';
import 'package:aashwaas/features/donation/domain/repositories/donation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final uploadPhotoUsecaseProvider = Provider<UploadPhotoUsecase>((ref) {
  final donationRepository = ref.read(donationRepositoryProvider);
  return UploadPhotoUsecase(donationRepository: donationRepository);
});

class UploadPhotoUsecase implements UsecaseWithParams<String, File> {
  final IDonationRepository _donationRepository;

  UploadPhotoUsecase({required IDonationRepository donationRepository})
    : _donationRepository = donationRepository;

  @override
  Future<Either<Failure, String>> call(File photo) {
    return _donationRepository.uploadPhoto(photo);
  }
}
