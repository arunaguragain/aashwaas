import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/auth/domain/entities/volunteer_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/repositories/volunteer_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockVolunteerAuthRepository extends Mock implements IVolunteerAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockVolunteerAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockVolunteerAuthRepository();
    usecase = LoginUsecase(authVolunteerRepository: mockRepository);
  });

  const tEmail = 'volunteer@example.com';
  const tPassword = 'password123';

  const tVolunteer = VolunteerAuthEntity(
    volunteerAuthId: '1',
    fullName: 'Test Volunteer',
    email: tEmail,
    phoneNumber: '9800000000',
  );

  group('LoginUsecase', () {
    test(
      'should return VolunteerAuthEntity when login is successful',
      () async {
        // Arrange
        when(
          () => mockRepository.loginVolunteer(tEmail, tPassword),
        ).thenAnswer((_) async => const Right(tVolunteer));

        // Act
        final result = await usecase(
          const LoginUsecaseParams(email: tEmail, password: tPassword),
        );

        // Assert
        expect(result, const Right(tVolunteer));
        verify(
          () => mockRepository.loginVolunteer(tEmail, tPassword),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return failure when login fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Invalid credentials');
      when(
        () => mockRepository.loginVolunteer(tEmail, tPassword),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const LoginUsecaseParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.loginVolunteer(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.loginVolunteer(tEmail, tPassword),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const LoginUsecaseParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.loginVolunteer(tEmail, tPassword)).called(1);
    });

    test('should pass correct email and password to repository', () async {
      // Arrange
      when(
        () => mockRepository.loginVolunteer(any(), any()),
      ).thenAnswer((_) async => const Right(tVolunteer));

      // Act
      await usecase(
        const LoginUsecaseParams(email: tEmail, password: tPassword),
      );

      // Assert
      verify(() => mockRepository.loginVolunteer(tEmail, tPassword)).called(1);
    });

    test(
      'should succeed with correct credentials and fail with wrong credentials',
      () async {
        // Arrange
        const wrongEmail = 'wrong@example.com';
        const wrongPassword = 'wrongpassword';
        const failure = ApiFailure(message: 'Invalid credentials');

        when(() => mockRepository.loginVolunteer(any(), any())).thenAnswer((
          invocation,
        ) async {
          final email = invocation.positionalArguments[0] as String;
          final password = invocation.positionalArguments[1] as String;

          if (email == tEmail && password == tPassword) {
            return const Right(tVolunteer);
          }
          return const Left(failure);
        });

        // Act & Assert 
        final successResult = await usecase(
          const LoginUsecaseParams(email: tEmail, password: tPassword),
        );
        expect(successResult, const Right(tVolunteer));

        // Act & Assert 
        final wrongEmailResult = await usecase(
          const LoginUsecaseParams(email: wrongEmail, password: tPassword),
        );
        expect(wrongEmailResult, const Left(failure));

        // Act & Assert 
        final wrongPasswordResult = await usecase(
          const LoginUsecaseParams(email: tEmail, password: wrongPassword),
        );
        expect(wrongPasswordResult, const Left(failure));
      },
    );
  });

  group('LoginUsecaseParams', () {
    test('should have correct props', () {
      // Arrange
      const params = LoginUsecaseParams(email: tEmail, password: tPassword);

      // Assert
      expect(params.props, [tEmail, tPassword]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = LoginUsecaseParams(email: tEmail, password: tPassword);
      const params2 = LoginUsecaseParams(email: tEmail, password: tPassword);

      // Assert
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      // Arrange
      const params1 = LoginUsecaseParams(email: tEmail, password: tPassword);
      const params2 = LoginUsecaseParams(
        email: 'other@email.com',
        password: tPassword,
      );

      // Assert
      expect(params1, isNot(params2));
    });
  });
}
