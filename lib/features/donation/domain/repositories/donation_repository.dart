import 'dart:io';
import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IDonationRepository {
  Future<Either<Failure, List<DonationEntity>>> getAllDonations();
  Future<Either<Failure, List<DonationEntity>>> getItemsByUser(String donorId);
  Future<Either<Failure, List<DonationEntity>>> getDonationsByCategory(String category);
  Future<Either<Failure, List<DonationEntity>>> getDonationsByStatus(String status);
  Future<Either<Failure, DonationEntity>> getDonationById(String donationId);
  Future<Either<Failure, bool>> createDonation(DonationEntity entity);
  Future<Either<Failure, bool>> updateDonation(DonationEntity entity);
  Future<Either<Failure, bool>> deleteDonation(String donationId);
  Future<Either<Failure, String>> uploadPhoto(File photo);
}
