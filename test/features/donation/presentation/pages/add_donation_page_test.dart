import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/donation/domain/usecases/create_donation_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/delete_donation_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/get_all_donations_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/get_donation_by_id_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/get_donations_by_user_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/update_donation_usecase.dart';
import 'package:aashwaas/features/donation/domain/usecases/upload_photo_usecase.dart';
import 'package:aashwaas/features/donation/presentation/pages/add_donation_page.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateDonationUsecase extends Mock implements CreateDonationUsecase {}

class MockGetAllDonationsUsecase extends Mock implements GetAllDonationsUsecase {}

class MockGetDonationByIdUsecase extends Mock implements GetDonationByIdUsecase {}

class MockGetDonationsByUserUsecase extends Mock implements GetDonationsByUserUsecase {}

class MockUpdateDonationUsecase extends Mock implements UpdateDonationUsecase {}

class MockDeleteDonationUsecase extends Mock implements DeleteDonationUsecase {}

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockCreateDonationUsecase mockCreateDonationUsecase;
  late MockGetAllDonationsUsecase mockGetAllDonationsUsecase;
  late MockGetDonationByIdUsecase mockGetDonationByIdUsecase;
  late MockGetDonationsByUserUsecase mockGetDonationsByUserUsecase;
  late MockUpdateDonationUsecase mockUpdateDonationUsecase;
  late MockDeleteDonationUsecase mockDeleteDonationUsecase;
  late MockUploadPhotoUsecase mockUploadPhotoUsecase;
  late MockUserSessionService mockUserSessionService;

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
    mockUserSessionService = MockUserSessionService();

    when(() => mockUserSessionService.getCurrentUserId()).thenReturn('donor1');
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        createDonationUsecaseProvider.overrideWithValue(mockCreateDonationUsecase),
        getAllDonationsUsecaseProvider.overrideWithValue(mockGetAllDonationsUsecase),
        getDonationByIdUsecaseProvider.overrideWithValue(mockGetDonationByIdUsecase),
        getDonationsByUserUsecaseProvider.overrideWithValue(mockGetDonationsByUserUsecase),
        updateDonationUsecaseProvider.overrideWithValue(mockUpdateDonationUsecase),
        deleteDonationUsecaseProvider.overrideWithValue(mockDeleteDonationUsecase),
        uploadPhotoUsecaseProvider.overrideWithValue(mockUploadPhotoUsecase),
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
      ],
      child: const MaterialApp(home: AddDonationScreen()),
    );
  }

  group('AddDonationScreen - UI Elements', () {
    testWidgets('should display app bar and form labels', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Add Donation'), findsOneWidget);
      expect(find.text('Item Name *'), findsOneWidget);
      expect(find.text('Category *'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Quantity *'), findsOneWidget);
      expect(find.text('Condition *'), findsOneWidget);
      expect(find.text('Pickup Location *'), findsOneWidget);
      expect(find.text('Photos'), findsOneWidget);
      expect(find.text('Add Photos'), findsOneWidget);
      expect(find.text('Submit Donation'), findsOneWidget);
    });

    testWidgets('should open photo picker sheet', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Photos'));
      await tester.pumpAndSettle();

      expect(find.text('Add Photo'), findsOneWidget);
      expect(find.text('Take Photo'), findsOneWidget);
      expect(find.text('Choose from Gallery'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });
  });

  group('AddDonationScreen - Form Input', () {
    testWidgets('should allow entering item name', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Winter Coat');
      await tester.pump();

      final field = tester.widget<TextFormField>(
        find.byType(TextFormField).at(0),
      );
      expect(field.controller?.text, 'Winter Coat');
    });

    testWidgets('should allow entering description', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Gently used items',
      );
      await tester.pump();

      final field = tester.widget<TextFormField>(
        find.byType(TextFormField).at(1),
      );
      expect(field.controller?.text, 'Gently used items');
    });

    testWidgets('should allow entering quantity', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(2), '5');
      await tester.pump();

      final field = tester.widget<TextFormField>(
        find.byType(TextFormField).at(2),
      );
      expect(field.controller?.text, '5');
    });

    testWidgets('should allow entering pickup location', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(3),
        'Kathmandu',
      );
      await tester.pump();

      final field = tester.widget<TextFormField>(
        find.byType(TextFormField).at(3),
      );
      expect(field.controller?.text, 'Kathmandu');
    });
  });

  group('AddDonationScreen - Form Validation', () {
    testWidgets('should show required field errors on submit', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Submit Donation'));
      await tester.pumpAndSettle();

      expect(find.text('This field is required'), findsWidgets);

      await tester.binding.setSurfaceSize(null);
    });
  });

  group('AddDonationScreen - Submission', () {
    testWidgets('should call create donation with correct params', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      CreateDonationParams? capturedParams;
      when(() => mockCreateDonationUsecase(any())).thenAnswer((invocation) async {
        capturedParams = invocation.positionalArguments[0] as CreateDonationParams;
        return const Left(ApiFailure(message: 'Test'));
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Blankets');
      await tester.enterText(find.byType(TextFormField).at(1), 'Warm blankets');
      await tester.enterText(find.byType(TextFormField).at(2), '3');
      await tester.enterText(find.byType(TextFormField).at(3), 'Lalitpur');
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Select Category'));
      await tester.tap(find.text('Select Category'), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clothes').last);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Select Condition'));
      await tester.tap(find.text('Select Condition'), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Good').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Submit Donation'));
      await tester.pumpAndSettle();

      verify(() => mockCreateDonationUsecase(any())).called(1);
      expect(capturedParams, isNotNull);
      expect(capturedParams?.itemName, 'Blankets');
      expect(capturedParams?.category, 'Clothes');
      expect(capturedParams?.description, 'Warm blankets');
      expect(capturedParams?.quantity, '3');
      expect(capturedParams?.condition, 'Good');
      expect(capturedParams?.pickupLocation, 'Lalitpur');
      expect(capturedParams?.donorId, 'donor1');
      expect(capturedParams?.media, isNull);

      await tester.binding.setSurfaceSize(null);
    });
  });
}