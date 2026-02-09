import 'package:aashwaas/features/ngo/data/models/ngo_api_model.dart';

abstract interface class INgoRemoteDataSource {
  Future<List<NgoApiModel>> getAllNgos();
  Future<NgoApiModel> getNgoById(String ngoId);
}
