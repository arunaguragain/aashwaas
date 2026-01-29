import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:equatable/equatable.dart';

enum DonationStatus {initial, loading, loaded, error, created, updated, deleted}

class DonationState extends Equatable {
  final DonationStatus status;
  final List<DonationEntity> donations;
  final List<DonationEntity> myDonations;
  final List<DonationEntity> pendingDonations;
  final List<DonationEntity> completedDonations;
  final DonationEntity? selectedDonation;
  final String? errorMessage;
  final String? uploadedPhotoUrl;
  final int totalDonationCount;

  const DonationState({
    this.status = DonationStatus.initial,
    this.donations = const [],
    this.myDonations = const [],
    this.pendingDonations = const [],
    this.completedDonations = const [],
    this.selectedDonation,
    this.errorMessage,
    this.uploadedPhotoUrl,
    this.totalDonationCount = 0,
  });

  DonationState copyWith({
    DonationStatus? status,
    List<DonationEntity>? donations,
    List<DonationEntity>? myDonations,
    List<DonationEntity>? pendingDonations,
    List<DonationEntity>? completedDonations,
    DonationEntity? selectedDonation,
    bool resetSelectedDonation = false,
    String? errorMessage,
    bool resetErrorMessage = false,
    String? uploadedPhotoUrl,
    bool resetUploadedPhotoUrl = false,
    int? totalDonationCount,
  }) {
    return DonationState(
      status: status ?? this.status,
      donations: donations ?? this.donations,
      myDonations: myDonations ?? this.myDonations,
      pendingDonations: pendingDonations ?? this.pendingDonations,
      completedDonations: completedDonations ?? this.completedDonations,
      selectedDonation: resetSelectedDonation
          ? null
          : (selectedDonation ?? this.selectedDonation),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      uploadedPhotoUrl: resetUploadedPhotoUrl
          ? null
          : (uploadedPhotoUrl ?? this.uploadedPhotoUrl),
      totalDonationCount: totalDonationCount ?? this.totalDonationCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        donations,
        myDonations,
        pendingDonations,
        completedDonations,
        selectedDonation,
        errorMessage,
        uploadedPhotoUrl,
        totalDonationCount,
      ];
}
