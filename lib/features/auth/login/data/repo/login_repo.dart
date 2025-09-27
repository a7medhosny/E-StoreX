import 'package:dio/dio.dart';
import 'package:ecommerce/core/helpers/token_helper.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/networking/estorex_api_service.dart';
import 'package:ecommerce/features/auth/login/data/models/auth_response_model.dart';
import 'package:ecommerce/features/auth/login/data/models/login_request_model.dart';
import 'package:ecommerce/features/auth/models/forgot_password_request.dart';
import 'package:ecommerce/features/auth/models/refresh_token_request.dart';
import 'package:ecommerce/features/auth/models/reset_password_request.dart';
import 'package:ecommerce/features/auth/register/data/models/error_response_model.dart';

class LoginRepo {
  final EStoreXApiService _apiService;

  LoginRepo(this._apiService);

  Future<AuthResponseModel> login(LoginRequestModel loginModel) async {
    try {
      return await _apiService.loginUser(loginModel);
    } on DioException catch (e) {
      throw _handleDioError(e, 'Login failed');
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }

  Future<AuthResponseModel> resetPassword({
    required String userId,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final request = ResetPasswordRequest(
        userId: userId,
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return await _apiService.resetPassword(request);
    } on DioException catch (e) {
      throw _handleDioError(e, 'Reset password failed');
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }

  Future<AuthResponseModel> forgotPassword({required String email}) async {
    try {
      final request = ForgotPasswordRequest(email: email);
      return await _apiService.forgotPassword(request);
    } on DioException catch (e) {
      throw _handleDioError(e, 'Forgot password failed');
    } catch (e) {
      throw Exception('Forgot password failed: $e');
    }
  }

  Future<AuthResponseModel> externalLogin({required String provider}) async {
    try {
      return await _apiService.externalLogin(provider);
    } on DioException catch (e) {
      throw _handleDioError(e, 'external login failed');
    } catch (e) {
      throw Exception('external login failed: $e');
    }
  }

  Future<AuthResponseModel> refreshToken({
    required String token,
    required String refreshToken,
  }) async {
    try {
      final request = RefreshTokenRequest(
        token: token,
        refreshToken: refreshToken,
      );
      AuthResponseModel authResponse = await _apiService.refreshToken(request);
      await TokenManager.clear();
      await TokenManager.saveLoginData(
        token: authResponse.token ?? '',
        refreshToken: authResponse.refreshToken ?? '',
        expiration: authResponse.expiration ?? '',
        refreshTokenExpirationDateTime:
            authResponse.refreshTokenExpirationDateTime ?? '',
        userName: authResponse.userName ?? '',
        email: authResponse.email ?? '',
        userId: TokenHelper.extractUserId(authResponse.token ?? '') ?? '',
      );
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to refresh token');
    } catch (e) {
      throw Exception('Refresh token failed: $e');
    }
  }

  // A reusable private method to handle and parse DioException errors.
  Exception _handleDioError(DioException e, String defaultMessage) {
    print('Status code: ${e.response?.statusCode}');
    print('Data type: ${e.response?.data.runtimeType}');
    print('Raw data: ${e.response?.data}');

    try {
      print("Error on login ${e.response?.data ?? {}}");
      final jsonMap = Map<String, dynamic>.from(e.response?.data ?? {});
      final errorResponse = ErrorResponseModel.fromJson(jsonMap);

      print('API error: ${errorResponse.message}');
      String errorMessage = errorResponse.message;

      if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
        errorMessage = errorResponse.errors!.join('\n');
      }

      return Exception(errorMessage.trim());
    } catch (jsonError) {
      print('Failed to parse error response: $jsonError');
      return Exception('$defaultMessage try again later');
    }
  }
}
