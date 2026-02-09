import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/services/connectivity/network_info.dart';
import 'package:aashwaas/features/ngo/data/datasources/ngo_datasource.dart';
import 'package:aashwaas/features/ngo/data/datasources/remote/ngo_remote_datasource.dart';
import 'package:aashwaas/features/ngo/data/models/ngo_api_model.dart';
import 'package:aashwaas/features/ngo/domain/entities/ngo_entity.dart';
import 'package:aashwaas/features/ngo/domain/repositories/ngo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ngoRepositoryProvider = Provider<INgoRepository>((ref) {
  final remoteDatasource = ref.read(ngoRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return NgoRepository(
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class NgoRepository implements INgoRepository {
  final INgoRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NgoRepository({
    required INgoRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<NgoEntity>>> getAllNgos() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllNgos();
        final entities = NgoApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }
    return const Left(NetworkFailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, NgoEntity>> getNgoById(String ngoId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getNgoById(ngoId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }
    return const Left(NetworkFailure(message: 'No internet connection'));
  }
}
