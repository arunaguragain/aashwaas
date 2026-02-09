import 'package:aashwaas/core/api/api_client.dart';
import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/features/ngo/data/datasources/ngo_datasource.dart';
import 'package:aashwaas/features/ngo/data/models/ngo_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ngoRemoteDataSourceProvider = Provider<INgoRemoteDataSource>((ref) {
  return NgoRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class NgoRemoteDataSource implements INgoRemoteDataSource {
  final ApiClient _apiClient;

  NgoRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<NgoApiModel>> getAllNgos() async {
    final response = await _apiClient.get(ApiEndpoints.ngos);
    final dataList = _extractList(response.data);
    return dataList
        .whereType<Map<String, dynamic>>()
        .map(NgoApiModel.fromJson)
        .toList();
  }

  @override
  Future<NgoApiModel> getNgoById(String ngoId) async {
    final response = await _apiClient.get(ApiEndpoints.ngoById(ngoId));
    final data = _extractMap(response.data);
    return NgoApiModel.fromJson(data);
  }

  List<dynamic> _extractList(dynamic payload) {
    if (payload is List) {
      return payload;
    }
    if (payload is Map<String, dynamic>) {
      final data = payload['data'];
      if (data is List) {
        return data;
      }
      if (data is Map<String, dynamic> && data['ngos'] is List) {
        return data['ngos'] as List;
      }
    }
    return const [];
  }

  Map<String, dynamic> _extractMap(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      final data = payload['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
      return payload;
    }
    return const <String, dynamic>{};
  }
}
