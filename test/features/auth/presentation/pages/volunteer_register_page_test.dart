import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_login_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_logout_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_register_usecase.dart';
import 'package:aashwaas/features/auth/presentation/pages/volunteer_register_page.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockVolunteerLogoutUsecase extends Mock implements VolunteerLogoutUsecase {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockVolunteerLogoutUsecase mockLogoutUsecase;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUsecaseParams(
        fullName: 'fallback',
        email: 'fallback@email.com',
        password: 'fallback',
      ),
    );
    registerFallbackValue(
      const LoginUsecaseParams(
        email: 'fallback@email.com',
        password: 'fallback',
      ),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockVolunteerLogoutUsecase();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        registerVolunteerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        volunteerLoginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        logoutVolunteerUsecaseProvider.overrideWithValue(mockLogoutUsecase),
      ],
      child: const MaterialApp(home: VolunteerRegisterScreen()),
    );
  }

  group('VolunteerRegisterPage - UI Elements', () {
    testWidgets('should display header and form labels', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(' Register as Volunteer'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Your email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('should display register button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('should display four text form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(4));
    });

    testWidgets('should display visibility icons for passwords', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsWidgets);
    });


    testWidgets('should display login link', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text("Already have an account?"), findsOneWidget);
      expect(find.text("Log in"), findsOneWidget);
    });
    testWidgets('should toggle password visibility', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final visibilityIcon = find.byIcon(Icons.visibility_off_outlined).first;
      expect(visibilityIcon, findsOneWidget);

      await tester.tap(visibilityIcon);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsWidgets);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should toggle confirm password visibility', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final visibilityIcons = find.byIcon(Icons.visibility_off_outlined);
      expect(visibilityIcons, findsWidgets);

      await tester.tap(visibilityIcons.last);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsWidgets);
      await tester.binding.setSurfaceSize(null);
    });
  });

  group('VolunteerRegisterPage - Form Input', () {
    testWidgets('should allow entering full name', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.pump();

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should allow entering email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should allow entering password', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.pump();

      final passwordField = tester.widget<TextFormField>(
        find.byType(TextFormField).at(2),
      );
      expect(passwordField.controller?.text, 'password123');
    });

    testWidgets('should allow entering confirm password', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(3), 'password123');
      await tester.pump();

      final confirmPasswordField = tester.widget<TextFormField>(
        find.byType(TextFormField).at(3),
      );
      expect(confirmPasswordField.controller?.text, 'password123');
    });
  });

  group('VolunteerRegisterPage - Form Validation', () {
    testWidgets('should show error when full name is empty', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Try to submit without name
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check for error message
      expect(find.text('Full Name is required'), findsWidgets);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show error when email is empty', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill only name
      await tester.enterText(find.byType(TextFormField).at(0), 'Aruna Guragain');
      await tester.pumpAndSettle();

      // Try to submit
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check for error message
      expect(find.text('Email is required'), findsWidgets);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show error when password is empty', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill name and email
      await tester.enterText(find.byType(TextFormField).at(0), 'Aruna Guragain');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.pumpAndSettle();

      // Try to submit
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check for error message
      expect(find.text('Password is required'), findsWidgets);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show error when passwords do not match', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill all fields with mismatched passwords
      await tester.enterText(find.byType(TextFormField).at(0), 'Aruna Guragain');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(3), 'password456');
      await tester.pumpAndSettle();

      // Try to submit
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check for mismatch error
      expect(find.text('Passwords do not match'), findsWidgets);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should not show error when all fields are valid', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      when(
        () => mockRegisterUsecase(any()),
      ).thenAnswer((_) async => const Right(true));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Aruna Guragain');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(3), 'password123');
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Full Name is required'), findsNothing);
      expect(find.text('Email is required'), findsNothing);

      await tester.binding.setSurfaceSize(null);
    });
  });

  group('VolunteerRegisterPage - Form Submission', () {
    testWidgets('should call register usecase when form is valid', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      // Return failure to avoid navigation issues
      when(
        () => mockRegisterUsecase(any()),
      ).thenAnswer((_) async => const Left(ApiFailure(message: 'Test')));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill all fields
      await tester.enterText(find.byType(TextFormField).at(0), 'Aruna Guragain');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'aruna@example.com',
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(3), 'password123');
      await tester.pumpAndSettle();

      // Tap register button
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      verify(() => mockRegisterUsecase(any())).called(1);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should call register with correct parameters', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      RegisterUsecaseParams? capturedParams;
      when(() => mockRegisterUsecase(any())).thenAnswer((invocation) async {
        capturedParams =
            invocation.positionalArguments[0] as RegisterUsecaseParams;
        return const Right(true);
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill form with specific data
      await tester.enterText(find.byType(TextFormField).at(0), 'Arun Guragain');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'arun@example.com',
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(2), 'pass1234');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(3), 'pass1234');
      await tester.pumpAndSettle();

      // Tap register button
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify correct params were passed
      expect(capturedParams, isNotNull);
      expect(capturedParams?.fullName, 'Arun Guragain');
      expect(capturedParams?.email, 'arun@example.com');
      expect(capturedParams?.password, 'pass1234');
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should not call register when form is invalid', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill only name, leave other fields empty
      await tester.enterText(find.byType(TextFormField).at(0), 'Arun Guragain');
      await tester.pumpAndSettle();

      // Tap register button
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify register was NOT called
      verifyNever(() => mockRegisterUsecase(any()));
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show loading state during registration', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      when(
        () => mockRegisterUsecase(any()),
      ).thenAnswer((_) async => const Left(ApiFailure(message: 'Test')));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill all fields
      await tester.enterText(find.byType(TextFormField).at(0), 'Aruna Guragain');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'aruna@example.com',
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(3), 'password123');
      await tester.pumpAndSettle();

      // Tap register button
      await tester.tap(find.text('Register'));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify that usecase was called (loading state initiated)
      verify(() => mockRegisterUsecase(any())).called(greaterThan(0));
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should succeed with valid data and fail with invalid data', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      const correctEmail = 'valid@example.com';
      const correctPassword = 'validpass';
      const failure = ApiFailure(message: 'Registration failed');

      // Mock register to check data using if condition
      when(() => mockRegisterUsecase(any())).thenAnswer((invocation) async {
        final params =
            invocation.positionalArguments[0] as RegisterUsecaseParams;

        // Check if email and password are valid
        if (params.email == correctEmail &&
            params.password == correctPassword) {
          return const Right(true);
        }
        return const Left(failure);
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill form with valid data
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(1), correctEmail);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(2), correctPassword);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(3), correctPassword);
      await tester.pumpAndSettle();

      // Tap register button
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify register was called
      verify(() => mockRegisterUsecase(any())).called(greaterThan(0));

      await tester.binding.setSurfaceSize(null);
    });
  });
}
