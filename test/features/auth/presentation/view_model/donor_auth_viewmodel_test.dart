import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/usecases/donor_login_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/donor_logout_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/donor_register_usecase.dart';
import 'package:aashwaas/features/auth/presentation/state/donor_auth_state.dart';
import 'package:aashwaas/features/auth/presentation/view_model/donor_auth_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockDonorLogoutUsecase extends Mock implements DonorLogoutUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockDonorLogoutUsecase mockLogoutUsecase;
  late MockUserSessionService mockUserSessionService;
  late ProviderContainer container;

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
    mockLogoutUsecase = MockDonorLogoutUsecase();
    mockUserSessionService = MockUserSessionService();

    container = ProviderContainer(
      overrides: [
        registerDonorUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        donorLoginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        logoutDonorUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  const tDonor = DonorAuthEntity(
    donorAuthId: '1',
    fullName: 'Test Donor',
    email: 'test@example.com',
    phoneNumber: '9800000000.',
  );

    group('register', () {
      test(
        'should emit registered state when registration is successful',
        () async {
          // Arrange
          when(
            () => mockRegisterUsecase(any()),
          ).thenAnswer((_) async => const Right(true));

          final viewModel = container.read(authDonorViewmodelProvider.notifier);

          // Act
          await viewModel.register(
            fullName: 'Test Donor',
            email: 'test@example.com',
            password: 'password123',
          );

          // Assert
          final state = container.read(authDonorViewmodelProvider);
          expect(state.status, AuthStatus.registered);
          verify(() => mockRegisterUsecase(any())).called(1);
        },
      );

      test('should emit error state when registration fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Email already exists');
        when(
          () => mockRegisterUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authDonorViewmodelProvider.notifier);

        // Act
        await viewModel.register(
          fullName: 'Test Donor',
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        final state = container.read(authDonorViewmodelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Email already exists');
        verify(() => mockRegisterUsecase(any())).called(1);
      });
    });

    group('login', () {
      test(
        'should emit authenticated state with donor when login is successful',
        () async {
          // Arrange
          when(
            () => mockLoginUsecase(any()),
          ).thenAnswer((_) async => const Right(tDonor));

          final viewModel = container.read(authDonorViewmodelProvider.notifier);

          // Act
          await viewModel.login(
            email: 'test@example.com',
            password: 'password',
          );

          // Assert
          final state = container.read(authDonorViewmodelProvider);
          expect(state.status, AuthStatus.authenticated);
          expect(state.authEntity, tDonor);
          verify(() => mockLoginUsecase(any())).called(1);
        },
      );

      test('should emit error state when login fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Invalid credentials');
        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authDonorViewmodelProvider.notifier);

        // Act
        await viewModel.login(email: 'test@example.com', password: 'password');

        // Assert
        final state = container.read(authDonorViewmodelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Invalid credentials');
        verify(() => mockLoginUsecase(any())).called(1);
      });

    });

    group('logout', () {
      test(
        'should emit unauthenticated state with null donor when successful',
        () async {
          // Arrange
          when(
            () => mockLogoutUsecase(),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockUserSessionService.clearUserSession(),
          ).thenAnswer((_) async => Future.value());

          final viewModel = container.read(authDonorViewmodelProvider.notifier);

          // Act
          await viewModel.logout();

          // Assert
          final state = container.read(authDonorViewmodelProvider);
          expect(state.status, AuthStatus.unauthenticated);
          expect(state.authEntity, isNull);
          verify(() => mockLogoutUsecase()).called(1);
          verify(() => mockUserSessionService.clearUserSession()).called(1);
        },
      );

      test('should emit error state when logout fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Logout failed');
        when(
          () => mockLogoutUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authDonorViewmodelProvider.notifier);

        // Act
        await viewModel.logout();

        // Assert
        final state = container.read(authDonorViewmodelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Logout failed');
        verify(() => mockLogoutUsecase()).called(1);
      });

      test('should not clear user session when logout fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Logout failed');
        when(
          () => mockLogoutUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authDonorViewmodelProvider.notifier);

        // Act
        await viewModel.logout();

        // Assert
        verifyNever(() => mockUserSessionService.clearUserSession());
      });
    });
}
