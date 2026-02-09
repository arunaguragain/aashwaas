import 'package:aashwaas/features/ngo/domain/entities/ngo_entity.dart';
import 'package:equatable/equatable.dart';

enum NgoStatus { initial, loading, loaded, error }

class NgoState extends Equatable {
  final NgoStatus status;
  final List<NgoEntity> ngos;
  final NgoEntity? selectedNgo;
  final String? errorMessage;

  const NgoState({
    this.status = NgoStatus.initial,
    this.ngos = const [],
    this.selectedNgo,
    this.errorMessage,
  });

  NgoState copyWith({
    NgoStatus? status,
    List<NgoEntity>? ngos,
    NgoEntity? selectedNgo,
    bool resetSelectedNgo = false,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return NgoState(
      status: status ?? this.status,
      ngos: ngos ?? this.ngos,
      selectedNgo: resetSelectedNgo ? null : (selectedNgo ?? this.selectedNgo),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, ngos, selectedNgo, errorMessage];
}
