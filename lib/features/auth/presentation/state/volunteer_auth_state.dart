import 'package:aashwaas/features/auth/domain/entities/volunteer_auth_entity.dart';
import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  error,
}

class VolunteerAuthState extends Equatable {
  final AuthStatus status;
  final VolunteerAuthEntity? authEntity;
  final String? errorMessage;

  const VolunteerAuthState({
    this.status = AuthStatus.initial,
    this.authEntity,
    this.errorMessage,
  });

  VolunteerAuthState copyWith({
    AuthStatus? status,
    VolunteerAuthEntity? authEntity,
    String? errorMessage,
  }) {
    return VolunteerAuthState(
      status: status ?? this.status,
      authEntity: authEntity ?? this.authEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, authEntity, errorMessage];
}
