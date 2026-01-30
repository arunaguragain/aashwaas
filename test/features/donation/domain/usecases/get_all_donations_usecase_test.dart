import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/domain/repositories/donation_repository.dart';
import 'package:aashwaas/features/donation/domain/usecases/get_all_donations_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockDonationRepository extends Mock implements IDonationRepository {}

void main() {
  late GetAllDonationsUsecase usecase;
  late MockDonationRepository mockRepository;

  setUp(() {
    mockRepository = MockDonationRepository();
    usecase = GetAllDonationsUsecase(donationRepository: mockRepository);
  });

  final tDonations = [
    const DonationEntity(
      donationId: '1',
      itemName: 'Books',
      category: 'Education',
      quantity: '5',
      condition: 'Good',
      pickupLocation: 'Kathmandu',
      status: 'pending',
    ),
    const DonationEntity(
      donationId: '2',
      itemName: 'Clothes',
      category: 'Clothes',
      quantity: '10',
      condition: 'Good',
      pickupLocation: 'Pokhara',
      status: 'completed',
    ),
  ];

  group('GetAllDonationsUsecase', () {
    test(
      'should return list of donations when repository call is successful',
      () async {
        // Arrange
        when(
          () => mockRepository.getAllDonations(),
        ).thenAnswer((_) async => Right(tDonations));

        // Act
        final result = await usecase();

        // Assert
        expect(result, Right(tDonations));
        verify(() => mockRepository.getAllDonations()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return failure when repository call fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to fetch donations');
      when(
        () => mockRepository.getAllDonations(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getAllDonations()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no donations exist', () async {
      // Arrange
      when(
        () => mockRepository.getAllDonations(),
      ).thenAnswer((_) async => const Right([]));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(<DonationEntity>[]));
      verify(() => mockRepository.getAllDonations()).called(1);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.getAllDonations(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getAllDonations()).called(1);
    });
  });
}
