
import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';
import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, registered, error }

class DonorAuthState extends Equatable {
  final AuthStatus status;
  final DonorAuthEntity? authEntity;
  final String? errorMessage;

  const DonorAuthState({
    this.status = AuthStatus.initial,
    this.authEntity,
    this.errorMessage,
  });

  DonorAuthState copyWith({
    AuthStatus? status,
    DonorAuthEntity? authEntity,
    String? errorMessage,
  }) {
    return DonorAuthState(
      status: status ?? this.status,
      authEntity: authEntity ?? this.authEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, authEntity, errorMessage];
}
