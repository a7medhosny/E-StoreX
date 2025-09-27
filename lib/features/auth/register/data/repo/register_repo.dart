import 'package:dio/dio.dart';
import 'package:ecommerce/features/auth/login/data/models/auth_response_model.dart';
import 'package:ecommerce/features/auth/register/data/models/error_response_model.dart';
import 'package:ecommerce/features/auth/register/data/models/register_request_model.dart';
import 'package:ecommerce/core/networking/estorex_api_service.dart';

class RegisterRepo {
  final EStoreXApiService _apiService;

  RegisterRepo(this._apiService);

  Future<AuthResponseModel> register(RegisterRequestModel registerModel) async {
    try {
      return await _apiService.registerUser(registerModel);
    } on DioException catch (e) {
      print('Data type: ${e.response?.data.runtimeType}');
      print('Raw data: ${e.response?.data}');

      late final ErrorResponseModel errorResponse;
      try {
        final jsonMap = Map<String, dynamic>.from(e.response?.data ?? {});
        errorResponse = ErrorResponseModel.fromJson(jsonMap);
      } catch (jsonError) {
        print('Failed to parse error response: $jsonError');
        throw Exception('Registration failed: could not parse error response');
      }

      print('Registration error: ${errorResponse.message}');
      String errorMessage = "";
      if (errorResponse.errors != null) {
        for (String message in errorResponse.errors!) {
          errorMessage += '$message\n';
        }
      }
      if (errorMessage.isEmpty) {
        errorMessage = errorResponse.message;
      }

      throw Exception(errorMessage.trim());
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
}
