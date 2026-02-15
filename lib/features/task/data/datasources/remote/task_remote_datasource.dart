import 'package:aashwaas/core/api/api_client.dart';
import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/core/services/storage/token_service.dart';
import 'package:aashwaas/features/task/data/datasources/task_datasource.dart';
import 'package:aashwaas/features/task/data/models/task_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';

final taskRemoteDataSourceProvider = Provider<ITaskRemoteDataSource>((ref) {
  return TaskRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class TaskRemoteDataSource implements ITaskRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;
  final UserSessionService _userSessionService;

  TaskRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService,
       _userSessionService = userSessionService;

  @override
  Future<TaskApiModel> getTaskById(String taskId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.taskById(taskId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return TaskApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<TaskApiModel>> getAllTasks() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.tasks,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((e) => TaskApiModel.fromJson(e)).toList();
  }

  @override
  Future<List<TaskApiModel>> getTasksByVolunteer(String volunteerId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.tasksByVolunteer(volunteerId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((e) => TaskApiModel.fromJson(e)).toList();
  }

  @override
  Future<List<TaskApiModel>> getMyTasks() async {
    final token = await _tokenService.getToken();
    // 1) Try /tasks/me
    try {
      final response = await _apiClient.get(
        ApiEndpoints.tasksMy,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data['data'] as List;
      return data.map((e) => TaskApiModel.fromJson(e)).toList();
    } on DioError catch (e) {
      // If backend doesn't expose /tasks/me, try /tasks/volunteer/{id}
      if (e.response?.statusCode == 404) {
        final userId = _userSessionService.getCurrentUserId();
        if (userId == null || userId.isEmpty) rethrow;

        try {
          final resp = await _apiClient.get(
            ApiEndpoints.tasksByVolunteer(userId),
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );
          final data = resp.data['data'] as List;
          return data.map((e) => TaskApiModel.fromJson(e)).toList();
        } on DioError catch (e2) {
          // If that also 404s or fails, fall back to fetching all tasks and filtering by volunteerId
          try {
            final allResp = await _apiClient.get(
              ApiEndpoints.tasks,
              options: Options(headers: {'Authorization': 'Bearer $token'}),
            );
            final allData = allResp.data['data'] as List;
            final models = allData
                .map((e) => TaskApiModel.fromJson(e))
                .toList();
            return models
                .where((m) => (m.volunteerId ?? '') == userId)
                .toList();
          } catch (_) {
            rethrow;
          }
        }
      }
      rethrow;
    }
  }

  @override
  Future<bool> acceptTask(String taskId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.taskAccept(taskId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['success'] == true;
  }

  @override
  Future<bool> completeTask(String taskId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.taskComplete(taskId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['success'] == true;
  }

  @override
  Future<bool> cancelTask(String taskId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      ApiEndpoints.taskCancel(taskId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['success'] == true;
  }
}

class ProviderReference {}
