import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/ngo/data/repositories/ngo_repository.dart';
import 'package:aashwaas/features/ngo/domain/entities/ngo_entity.dart';
import 'package:aashwaas/features/ngo/domain/repositories/ngo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllNgosUsecaseProvider = Provider<GetAllNgosUsecase>((ref) {
  final ngoRepository = ref.read(ngoRepositoryProvider);
  return GetAllNgosUsecase(ngoRepository: ngoRepository);
});

class GetAllNgosUsecase implements UsecaseWithoutParams<List<NgoEntity>> {
  final INgoRepository _ngoRepository;

  GetAllNgosUsecase({required INgoRepository ngoRepository})
    : _ngoRepository = ngoRepository;

  @override
  Future<Either<Failure, List<NgoEntity>>> call() {
    return _ngoRepository.getAllNgos();
  }
}
