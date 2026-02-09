import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/ngo/domain/entities/ngo_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class INgoRepository {
  Future<Either<Failure, List<NgoEntity>>> getAllNgos();
  Future<Either<Failure, NgoEntity>> getNgoById(String ngoId);
}
