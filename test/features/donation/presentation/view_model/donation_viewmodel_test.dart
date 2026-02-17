import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/domain/usecases/create_donation_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/delete_donation_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/get_all_donations_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/get_donation_by_id_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/get_donations_by_user_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/update_donation_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/upload_photo_usecase.dart';
import 'package:aashwaas/features/donation/presentation/state/donation_state.dart';
import 'package:aashwaas/features/donation/presentation/view_model/donation_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

//  flutter test --coverage
//  flutter pub run test_cov_console

class MockCreateDonationUsecase extends Mock implements CreateDonationUsecase {}

class MockGetAllDonationsUsecase extends Mock implements GetAllDonationsUsecase {}

class MockGetDonationByIdUsecase extends Mock implements GetDonationByIdUsecase {}

class MockGetDonationsByUserUsecase extends Mock implements GetDonationsByUserUsecase {}

class MockUpdateDonationUsecase extends Mock implements UpdateDonationUsecase {}

class MockDeleteDonationUsecase extends Mock implements DeleteDonationUsecase {}

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

void main() {
  late MockCreateDonationUsecase mockCreateDonationUsecase;
  late MockGetAllDonationsUsecase mockGetAllDonationsUsecase;
  late MockGetDonationByIdUsecase mockGetDonationByIdUsecase;
  late MockGetDonationsByUserUsecase mockGetDonationsByUserUsecase;
  late MockUpdateDonationUsecase mockUpdateDonationUsecase;
  late MockDeleteDonationUsecase mockDeleteDonationUsecase;
  late MockUploadPhotoUsecase mockUploadPhotoUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const CreateDonationParams(
        itemName: 'fallback',
        category: 'fallback',
        quantity: '1',
        condition: 'fallback',
        pickupLocation: 'fallback',
      ),
    );
    registerFallbackValue(const GetDonationByIdParams(donationId: 'fallback'));
    registerFallbackValue(const GetDonationsByUserParams(donorId: 'fallback'));
    registerFallbackValue(
      const UpdateDonationParams(
        donationId: 'fallback',
        itemName: 'fallback',
        category: 'fallback',
        quantity: '1',
        condition: 'fallback',
        pickupLocation: 'fallback',
      ),
    );
    registerFallbackValue(const DeleteDonationParams(donationId: 'fallback'));
    registerFallbackValue(File('fallback'));
  });

  setUp(() {
    mockCreateDonationUsecase = MockCreateDonationUsecase();
    mockGetAllDonationsUsecase = MockGetAllDonationsUsecase();
    mockGetDonationByIdUsecase = MockGetDonationByIdUsecase();
    mockGetDonationsByUserUsecase = MockGetDonationsByUserUsecase();
    mockUpdateDonationUsecase = MockUpdateDonationUsecase();
    mockDeleteDonationUsecase = MockDeleteDonationUsecase();
    mockUploadPhotoUsecase = MockUploadPhotoUsecase();

    container = ProviderContainer(
      overrides: [
        createDonationUsecaseProvider.overrideWithValue(
          mockCreateDonationUsecase,
        ),
        getAllDonationsUsecaseProvider.overrideWithValue(
          mockGetAllDonationsUsecase,
        ),
        getDonationByIdUsecaseProvider.overrideWithValue(
          mockGetDonationByIdUsecase,
        ),
        getDonationsByUserUsecaseProvider.overrideWithValue(
          mockGetDonationsByUserUsecase,
        ),
        updateDonationUsecaseProvider.overrideWithValue(
          mockUpdateDonationUsecase,
        ),
        deleteDonationUsecaseProvider.overrideWithValue(
          mockDeleteDonationUsecase,
        ),
        uploadPhotoUsecaseProvider.overrideWithValue(mockUploadPhotoUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  const tDonation = DonationEntity(
    donationId: '1',
    itemName: 'Books',
    category: 'Education',
    quantity: '5',
    condition: 'Good',
    pickupLocation: 'Kathmandu',
    donorId: 'donor1',
    status: 'pending',
  );

  const tDonation2 = DonationEntity(
    donationId: '2',
    itemName: 'Clothes',
    category: 'Apparel',
    quantity: '10',
    condition: 'Good',
    pickupLocation: 'Pokhara',
    status: 'completed',
  );

  group('DonationViewModel', () {

      test('should return photo url when upload is successful', () async {
        // Arrange
        const tPhotoUrl = 'https://example.com/photo.jpg';
        when(
          () => mockUploadPhotoUsecase(any()),
        ).thenAnswer((_) async => const Right(tPhotoUrl));

        final viewModel = container.read(donationViewModelProvider.notifier);

        // Act
        final result = await viewModel.uploadPhoto(File('test.jpg'));

        // Assert
        expect(result, tPhotoUrl);
        final state = container.read(donationViewModelProvider);
        expect(state.uploadedPhotoUrl, tPhotoUrl);
        expect(state.status, DonationStatus.loaded);
        verify(() => mockUploadPhotoUsecase(any())).called(1);
      });

      test(
        'should emit created state when donation is created successfully',
        () async {
          // Arrange
          when(
            () => mockCreateDonationUsecase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetAllDonationsUsecase(),
          ).thenAnswer((_) async => const Right([tDonation]));

          final viewModel = container.read(donationViewModelProvider.notifier);

          // Act
          await viewModel.createDonation(
            itemName: tDonation.itemName,
            category: tDonation.category,
            quantity: tDonation.quantity,
            condition: tDonation.condition,
            pickupLocation: tDonation.pickupLocation,
          );
          // Wait for getAllDonations to complete
          await Future.delayed(const Duration(milliseconds: 100));

          // Assert - After creation, state should have donations from getAllDonations call
          final state = container.read(donationViewModelProvider);
          expect(state.donations, [tDonation]);
          verify(() => mockCreateDonationUsecase(any())).called(1);
          verify(() => mockGetAllDonationsUsecase()).called(1);
        },
      );

      test('should load all donations and categorize by status', () async {
        // Arrange
        final donations = [tDonation, tDonation2];
        when(
          () => mockGetAllDonationsUsecase(),
        ).thenAnswer((_) async => Right(donations));

        final viewModel = container.read(donationViewModelProvider.notifier);

        // Act
        await viewModel.getAllDonations();

        // Assert
        final state = container.read(donationViewModelProvider);
        expect(state.status, DonationStatus.loaded);
        expect(state.donations, donations);
        expect(state.pendingDonations, hasLength(1));
        expect(state.completedDonations, hasLength(1));
        expect(state.totalDonationCount, 2);
        verify(() => mockGetAllDonationsUsecase()).called(1);
      });

      test('should load donation by id', () async {
        // Arrange
        when(
          () => mockGetDonationByIdUsecase(any()),
        ).thenAnswer((_) async => const Right(tDonation));

        final viewModel = container.read(donationViewModelProvider.notifier);

        // Act
        await viewModel.getDonationById('1');

        // Assert
        final state = container.read(donationViewModelProvider);
        expect(state.status, DonationStatus.loaded);
        expect(state.selectedDonation, tDonation);
        verify(() => mockGetDonationByIdUsecase(any())).called(1);
      });

      test('should load donations by donor id', () async {
        // Arrange
        final donations = [tDonation];
        when(
          () => mockGetDonationsByUserUsecase(any()),
        ).thenAnswer((_) async => Right(donations));

        final viewModel = container.read(donationViewModelProvider.notifier);

        // Act
        await viewModel.getMyDonations();

        // Assert
        final state = container.read(donationViewModelProvider);
        expect(state.status, DonationStatus.loaded);
        expect(state.myDonations, donations);
        expect(state.totalDonationCount, 1);
        verify(() => mockGetDonationsByUserUsecase(any())).called(1);
      });

      test('should emit updated state when update is successful', () async {
        // Arrange
        when(
          () => mockUpdateDonationUsecase(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockGetAllDonationsUsecase(),
        ).thenAnswer((_) async => const Right([tDonation]));

        final viewModel = container.read(donationViewModelProvider.notifier);

        // Act
        await viewModel.updateDonation(
          donationId: '1',
          itemName: tDonation.itemName,
          category: tDonation.category,
          quantity: tDonation.quantity,
          condition: tDonation.condition,
          pickupLocation: tDonation.pickupLocation,
        );
        // Wait for getAllDonations to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(donationViewModelProvider);
        expect(state.donations, [tDonation]);
        verify(() => mockUpdateDonationUsecase(any())).called(1);
        verify(() => mockGetAllDonationsUsecase()).called(1);
      });

      test('should emit deleted state when deletion is successful', () async {
        // Arrange
        when(
          () => mockDeleteDonationUsecase(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockGetAllDonationsUsecase(),
        ).thenAnswer((_) async => const Right([tDonation]));

        final viewModel = container.read(donationViewModelProvider.notifier);

        // Act
        await viewModel.deleteDonation('1');
        // Wait for getAllDonations to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - After deletion, state should have donations from getAllDonations call
        final state = container.read(donationViewModelProvider);
        expect(state.donations, [tDonation]);
        verify(() => mockDeleteDonationUsecase(any())).called(1);
        verify(() => mockGetAllDonationsUsecase()).called(1);
      });
  });
}
