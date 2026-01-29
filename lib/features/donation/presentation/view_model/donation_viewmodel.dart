import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/donation/domain/usecases/create_donation_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/delete_donation_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/get_all_donations_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/get_donation_by_id_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/get_donations_by_user_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/update_donation_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/upload_photo_usecase.dart';
import 'package:aashwaas/features/donation/presentation/state/donation_state.dart';

final donationViewModelProvider =
    NotifierProvider<DonationViewModel, DonationState>(DonationViewModel.new);

class DonationViewModel extends Notifier<DonationState> {
  late final GetAllDonationsUsecase _getAllDonationsUsecase;
  late final GetDonationByIdUsecase _getDonationByIdUsecase;
  late final GetDonationsByUserUsecase _getDonationsByUserUsecase;
  late final CreateDonationUsecase _createDonationUsecase;
  late final UpdateDonationUsecase _updateDonationUsecase;
  late final DeleteDonationUsecase _deleteDonationUsecase;
  late final UploadPhotoUsecase _uploadPhotoUsecase;

  @override
  DonationState build() {
    _getAllDonationsUsecase = ref.read(getAllDonationsUsecaseProvider);
    _getDonationByIdUsecase = ref.read(getDonationByIdUsecaseProvider);
    _getDonationsByUserUsecase = ref.read(getDonationsByUserUsecaseProvider);
    _createDonationUsecase = ref.read(createDonationUsecaseProvider);
    _updateDonationUsecase = ref.read(updateDonationUsecaseProvider);
    _deleteDonationUsecase = ref.read(deleteDonationUsecaseProvider);
    _uploadPhotoUsecase = ref.read(uploadPhotoUsecaseProvider);
    return const DonationState();
  }

  Future<String?> uploadPhoto(File photo) async {
    state = state.copyWith(status: DonationStatus.loading);

    final result = await _uploadPhotoUsecase(photo);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: DonationStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (url) {
        state = state.copyWith(
          status: DonationStatus.loaded,
          uploadedPhotoUrl: url,
        );
        return url;
      },
    );
  }

  Future<void> createDonation({
    required String itemName,
    required String category,
    String? description,
    required String quantity,
    required String condition,
    required String pickupLocation,
    String? media,
    String? donorId,
  }) async {
    state = state.copyWith(status: DonationStatus.loading);

    final result = await _createDonationUsecase(
      CreateDonationParams(
        itemName: itemName,
        category: category,
        description: description,
        quantity: quantity,
        condition: condition,
        pickupLocation: pickupLocation,
        media: media,
        donorId: donorId,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: DonationStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(
          status: DonationStatus.created,
          resetUploadedPhotoUrl: true,
        );
        getAllDonations();
      },
    );
  }

  Future<void> getAllDonations() async {
    state = state.copyWith(status: DonationStatus.loading);

    final result = await _getAllDonationsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: DonationStatus.error,
        errorMessage: failure.message,
      ),
      (donations) {
        final pending = donations.where((d) => d.status == 'pending').toList();
        final completed = donations
            .where((d) => d.status == 'completed')
            .toList();
        state = state.copyWith(
          status: DonationStatus.loaded,
          donations: donations,
          pendingDonations: pending,
          completedDonations: completed,
          totalDonationCount: donations.length,
        );
      },
    );
  }

  Future<void> getDonationById(String donationId) async {
    state = state.copyWith(status: DonationStatus.loading);

    final result = await _getDonationByIdUsecase(
      GetDonationByIdParams(donationId: donationId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: DonationStatus.error,
        errorMessage: failure.message,
      ),
      (donation) => state = state.copyWith(
        status: DonationStatus.loaded,
        selectedDonation: donation,
      ),
    );
  }

  Future<void> getMyDonations(String donorId) async {
    state = state.copyWith(status: DonationStatus.loading);

    final result = await _getDonationsByUserUsecase(
      GetDonationsByUserParams(donorId: donorId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: DonationStatus.error,
        errorMessage: failure.message,
      ),
      (donations) => state = state.copyWith(
        status: DonationStatus.loaded,
        myDonations: donations,
        totalDonationCount: donations.length,
      ),
    );
  }

  Future<void> updateDonation({
    required String donationId,
    required String itemName,
    required String category,
    String? description,
    required String quantity,
    required String condition,
    required String pickupLocation,
    String? media,
    String? donorId,
    String? status,
  }) async {
    state = state.copyWith(status: DonationStatus.loading);

    final result = await _updateDonationUsecase(
      UpdateDonationParams(
        donationId: donationId,
        itemName: itemName,
        category: category,
        description: description,
        quantity: quantity,
        condition: condition,
        pickupLocation: pickupLocation,
        media: media,
        donorId: donorId,
        status: status,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: DonationStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: DonationStatus.updated);
        getAllDonations();
      },
    );
  }

  Future<void> deleteDonation(String donationId) async {
    state = state.copyWith(status: DonationStatus.loading);

    final result = await _deleteDonationUsecase(
      DeleteDonationParams(donationId: donationId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: DonationStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: DonationStatus.deleted);
        getAllDonations();
      },
    );
  }

  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void clearSelectedDonation() {
    state = state.copyWith(resetSelectedDonation: true);
  }

  void clearDonationState() {
    state = state.copyWith(
      status: DonationStatus.initial,
      resetUploadedPhotoUrl: true,
      resetErrorMessage: true,
    );
  }
}
