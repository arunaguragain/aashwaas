import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/domain/repositories/donation_repository.dart';
import 'package:aashwaas/features/donation/domain/usecases/create_donation_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockDonationRepository extends Mock implements IDonationRepository {}

void main() {
  late CreateDonationUsecase usecase;
  late MockDonationRepository mockRepository;

  setUp(() {
    mockRepository = MockDonationRepository();
    usecase = CreateDonationUsecase(donationRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const DonationEntity(
        itemName: 'fallback',
        category: 'fallback',
        quantity: '1',
        condition: 'fallback',
        pickupLocation: 'fallback',
      ),
    );
  });

  const tItemName = 'Books';
  const tCategory = 'Education';
  const tDescription = 'Used textbooks';
  const tQuantity = '5';
  const tCondition = 'Good';
  const tPickupLocation = 'Kathmandu';
  const tMedia = 'image.jpg';
  const tDonorId = 'donor123';

  test('should return true when donation is created successfully', () async {
    // Arrange
    when(
      () => mockRepository.createDonation(any()),
    ).thenAnswer((_) async => const Right(true));

    // Act
    final result = await usecase(
      const CreateDonationParams(
        itemName: tItemName,
        category: tCategory,
        description: tDescription,
        quantity: tQuantity,
        condition: tCondition,
        pickupLocation: tPickupLocation,
        media: tMedia,
        donorId: tDonorId,
      ),
    );

    // Assert
    expect(result, const Right(true));
    verify(() => mockRepository.createDonation(any())).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should pass DonationEntity with correct data to repository', () async {
    // Arrange
    DonationEntity? capturedEntity;
    when(() => mockRepository.createDonation(any())).thenAnswer((invocation) {
      capturedEntity = invocation.positionalArguments[0] as DonationEntity;
      return Future.value(const Right(true));
    });

    // Act
    await usecase(
      const CreateDonationParams(
        itemName: tItemName,
        category: tCategory,
        description: tDescription,
        quantity: tQuantity,
        condition: tCondition,
        pickupLocation: tPickupLocation,
        media: tMedia,
        donorId: tDonorId,
      ),
    );

    // Assert
    expect(capturedEntity?.itemName, tItemName);
    expect(capturedEntity?.category, tCategory);
    expect(capturedEntity?.description, tDescription);
    expect(capturedEntity?.quantity, tQuantity);
    expect(capturedEntity?.condition, tCondition);
    expect(capturedEntity?.pickupLocation, tPickupLocation);
    expect(capturedEntity?.media, tMedia);
    expect(capturedEntity?.donorId, tDonorId);
    expect(capturedEntity?.donationId, isNull);
  });


  test('should return NetworkFailure when there is no internet', () async {
    // Arrange
    const failure = NetworkFailure();
    when(
      () => mockRepository.createDonation(any()),
    ).thenAnswer((_) async => const Left(failure));

    // Act
    final result = await usecase(
      const CreateDonationParams(
        itemName: tItemName,
        category: tCategory,
        quantity: tQuantity,
        condition: tCondition,
        pickupLocation: tPickupLocation,
      ),
    );

    // Assert
    expect(result, const Left(failure));
    verify(() => mockRepository.createDonation(any())).called(1);
  });

  test('should handle optional fields correctly when they are null', () async {
    // Arrange
    DonationEntity? capturedEntity;
    when(() => mockRepository.createDonation(any())).thenAnswer((invocation) {
      capturedEntity = invocation.positionalArguments[0] as DonationEntity;
      return Future.value(const Right(true));
    });

    // Act
    await usecase(
      const CreateDonationParams(
        itemName: tItemName,
        category: tCategory,
        quantity: tQuantity,
        condition: tCondition,
        pickupLocation: tPickupLocation,
      ),
    );

    // Assert
    expect(capturedEntity?.description, isNull);
    expect(capturedEntity?.media, isNull);
    expect(capturedEntity?.donorId, isNull);
  });

  group('CreateDonationParams', () {
    test('should have correct props ', () {
      // Arrange
      const params = CreateDonationParams(
        itemName: tItemName,
        category: tCategory,
        description: tDescription,
        quantity: tQuantity,
        condition: tCondition,
        pickupLocation: tPickupLocation,
        media: tMedia,
        donorId: tDonorId,
      );

      // Assert
      expect(params.props, [
        tItemName,
        tCategory,
        tDescription,
        tQuantity,
        tCondition,
        tPickupLocation,
        tMedia,
        tDonorId,
      ]);
    });

    test('two params with same data should be equal', () {
      // Arrange
      const params1 = CreateDonationParams(
        itemName: tItemName,
        category: tCategory,
        quantity: tQuantity,
        condition: tCondition,
        pickupLocation: tPickupLocation,
      );
      const params2 = CreateDonationParams(
        itemName: tItemName,
        category: tCategory,
        quantity: tQuantity,
        condition: tCondition,
        pickupLocation: tPickupLocation,
      );

      // Assert
      expect(params1, params2);
    });
  });
}
