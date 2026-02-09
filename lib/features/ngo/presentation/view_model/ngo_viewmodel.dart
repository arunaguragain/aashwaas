import 'package:aashwaas/features/ngo/domain/usecases/get_all_ngos_usecase.dart';
import 'package:aashwaas/features/ngo/presentation/state/ngo_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ngoViewModelProvider = NotifierProvider<NgoViewModel, NgoState>(
  NgoViewModel.new,
);

class NgoViewModel extends Notifier<NgoState> {
  late final GetAllNgosUsecase _getAllNgosUsecase;

  @override
  NgoState build() {
    _getAllNgosUsecase = ref.read(getAllNgosUsecaseProvider);
    return const NgoState();
  }

  Future<void> getAllNgos() async {
    state = state.copyWith(status: NgoStatus.loading);

    final result = await _getAllNgosUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: NgoStatus.error,
        errorMessage: failure.message,
      ),
      (ngos) => state = state.copyWith(status: NgoStatus.loaded, ngos: ngos),
    );
  }
}
