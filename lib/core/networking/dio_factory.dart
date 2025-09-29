import 'package:dio/dio.dart';
import 'package:ecommerce/core/DI/get_it.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:flutter/material.dart';

import '../networking/api_constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DioFactory {
  DioFactory._();

  static Dio? _dio;
  static final Dio _refreshDio = Dio();

  /// لإلغاء الريكوستات لما التوكين يخلص
  static final CancelToken _cancelToken = CancelToken();

  static Dio getDio() {
    if (_dio == null) {
      _dio = Dio()
        ..options.connectTimeout = const Duration(seconds: 30)
        ..options.receiveTimeout = const Duration(seconds: 30);

      _dio!.interceptors.add(_loggerInterceptor());
      _dio!.interceptors.add(_addAPIKey());
    }
    return _dio!;
  }

  static Interceptor _loggerInterceptor() {
    return LogInterceptor(
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
    );
  }

  static Interceptor _addAPIKey() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['X-API-KEY'] =
            "ovuPaA2bJcgksW6yONrlDYtKweqihHfGnd9pI1FMVRmCTzE7UBx03SXZ8QL5j4";
        handler.next(options);
      },
    );
  }

  static Interceptor? _authInterceptorInstance;

  static void afterLoginInterceptor() {
    if (_authInterceptorInstance == null) {
      _authInterceptorInstance = _authInterceptor();
      _dio!.interceptors.add(_authInterceptorInstance!);
    }
  }

  static void removeAuthInterceptor() {
    if (_authInterceptorInstance != null) {
      _dio?.interceptors.remove(_authInterceptorInstance);
      _authInterceptorInstance = null;
    }
  }

  static Interceptor _authInterceptor() {
    return QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        if (TokenManager.isTokenExpired()) {

            _handleTokenExpired();
            return handler.reject(
              DioException(
                requestOptions: options,
                error: "Session expired, please login again",
                type: DioExceptionType.cancel,
              ),
            );
          // // لو لسه refresh valid
          // if (!TokenManager.isRefreshTokenExpired()) {
          //   try {
          //     final response = await _refreshDio.post(
          //       "${ApiConstants.baseUrl}${ApiConstants.refreshToken}",
          //       data: {
          //         "token": TokenManager.token,
          //         "refreshToken": TokenManager.refreshToken,
          //       },
          //     );

          //     final newToken = response.data["token"];
          //     final newRefreshToken = response.data["refreshToken"];
          //     final expiration = response.data["expiration"];
          //     final refreshExpiration =
          //         response.data["refreshTokenExpirationDateTime"];

          //     await TokenManager.clear();
          //     await TokenManager.saveLoginData(
          //       token: newToken,
          //       refreshToken: newRefreshToken,
          //       expiration: expiration,
          //       refreshTokenExpirationDateTime: refreshExpiration,
          //       userName: TokenManager.userName ?? '',
          //       email: TokenManager.email ?? '',
          //       userId: TokenManager.userId ?? '',
          //     );

          //     // 🟢 حط التوكين الجديد
          //     options.headers['Authorization'] = 'Bearer $newToken';
          //     options.headers['Accept'] = 'application/json';
          //     return handler.next(options);
          //   } catch (e) {
          //     // ❌ فشل تجديد التوكين
          //     _handleTokenExpired();
          //     return handler.reject(
          //       DioException(
          //         requestOptions: options,
          //         error: "Session expired, please login again",
          //         type: DioExceptionType.cancel,
          //       ),
          //     );
          //   }
          // } else {
          //   // ❌ Refresh كمان منتهي
          //   _handleTokenExpired();
          //   return handler.reject(
          //     DioException(
          //       requestOptions: options,
          //       error: "Session expired, please login again",
          //       type: DioExceptionType.cancel,
          //     ),
          //   );
          // }
        } else {
          // التوكين لسه صالح
          options.headers['Authorization'] = 'Bearer ${TokenManager.token}';
          options.headers['Accept'] = 'application/json';
          handler.next(options);
        }
      },
    );
  }

  /// 🛑 هنا بنوقف كل الريكوستات ونمسح التوكين ونروح للـ Login
  static Future<void> _handleTokenExpired() async {
    try {
      _cancelToken.cancel("Token expired, requests cancelled");
    } catch (_) {}

    await TokenManager.clear();
    removeAuthInterceptor();

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      Routes.loginRegisterTabSwitcher,
      (route) => false,
    );
  }
}
