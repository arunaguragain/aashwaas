import 'package:aashwaas/core/api/api_client.dart';
import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/core/services/storage/token_service.dart';
import 'package:aashwaas/features/task/data/datasources/task_datasource.dart';
import 'package:aashwaas/features/task/data/models/task_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskRemoteDataSourceProvider = Provider<ITaskRemoteDataSource>((ref) {
  return TaskRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class TaskRemoteDataSource implements ITaskRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  TaskRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

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
    final response = await _apiClient.get(
      ApiEndpoints.tasksMy,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((e) => TaskApiModel.fromJson(e)).toList();
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
