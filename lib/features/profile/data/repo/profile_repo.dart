import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/core/networking/estorex_api_service.dart';
import 'package:ecommerce/features/auth/login/data/models/auth_response_model.dart';
import 'package:ecommerce/features/auth/models/reset_password_request.dart';
import 'package:ecommerce/features/auth/register/data/models/error_response_model.dart';
import 'package:ecommerce/features/profile/data/models/profile_response_model.dart';
import 'package:ecommerce/features/profile/data/models/update_profile_request.dart';

class ProfileRepo {
  EStoreXApiService apiService;
  ProfileRepo({required this.apiService});
  Future<ProfileResponseModel> getUserProfile() async {
    try {
      final response = await apiService.getUserProfile();
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to load user profile');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<AuthResponseModel> updateUserProfile(
    UpdateProfileRequest updatedProfileRequest,
  ) async {
    try {
      final response = await apiService.updateUserProfile(
        updatedProfileRequest,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to update user profile');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<AuthResponseModel> uploadUserPhoto(File file) async {
    try {
      final response = await apiService.uploadUserPhoto(file);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to upload profile photo');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<AuthResponseModel> logout() async {
    try {
      final response = await apiService.logout();
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to logout');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<AuthResponseModel> deleteAccount() async {
    try {
      final response = await apiService.deleteAccount();
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to delete account');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  String _handleDioError(DioException e, String defaultMessage) {
    print('Status code: ${e.response?.statusCode}');
    print('error message: ${e.message}');
    print("BODY: ${e.response?.data}");

    String errorMessage = defaultMessage;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage =
            'Connection timed out. Please check your internet connection.';
        break;

      case DioExceptionType.badResponse:
        if (e.response != null && e.response!.data != null) {
          final data = e.response!.data;

          if (data is Map<String, dynamic>) {
            // ✅ دايمًا errors = List<String>
            if (data['errors'] != null && data['errors'] is List) {
              errorMessage = (data['errors'] as List)
                  .map((e) => e.toString())
                  .join('\n'); // يرجع كل الرسائل في سطر جديد
            } else if (data['message'] != null) {
              errorMessage = data['message'].toString();
            } else {
              errorMessage = e.response!.statusMessage ?? errorMessage;
            }
          }
          print(
            'API Error - Status Code: ${e.response!.statusCode}, Message: $errorMessage',
          );
        } else {
          errorMessage =
              'Server error: ${e.response?.statusCode ?? ''} - ${e.response?.statusMessage ?? ''}';
        }
        break;

      case DioExceptionType.cancel:
        errorMessage = 'Request to server was cancelled.';
        break;

      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection or host unreachable.';
        break;

      case DioExceptionType.badCertificate:
        errorMessage = 'Bad SSL certificate.';
        break;

      case DioExceptionType.unknown:
      default:
        errorMessage = 'An unknown error occurred: ${e.message}';
        break;
    }

    return errorMessage;
  }
}
