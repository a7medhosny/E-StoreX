import 'package:dio/dio.dart';
import 'package:ecommerce/core/DI/get_it.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:flutter/material.dart';

import '../networking/api_constants.dart'; // 🟢 تأكد أنك عامل import للـ ApiConstants

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DioFactory {
  DioFactory._();

  static Dio? _dio;
  static final Dio _refreshDio = Dio(); // 🔑 Dio منفصل للـ Refresh

  static Dio getDio() {
    if (_dio == null) {
      _dio =
          Dio()
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
          if (!TokenManager.isRefreshTokenExpired()) {
            try {
              print("From Token Exp try to refresh");

              final response = await _refreshDio.post(
                "${ApiConstants.baseUrl}${ApiConstants.refreshToken}",
                data: {
                  "token": TokenManager.token,
                  "refreshToken": TokenManager.refreshToken,
                },
              );

              final newToken = response.data["token"];
              final newRefreshToken = response.data["refreshToken"];
              final expiration = response.data["expiration"];
              final refreshExpiration =
                  response.data["refreshTokenExpirationDateTime"];

              await TokenManager.clear();
              await TokenManager.saveLoginData(
                token: newToken,
                refreshToken: newRefreshToken,
                expiration: expiration,
                refreshTokenExpirationDateTime: refreshExpiration,
                userName: TokenManager.userName ?? '',
                email: TokenManager.email ?? '',
                userId: TokenManager.userId ?? '',
              );

              // 🟢 أضف التوكن الجديد
              options.headers['Authorization'] = 'Bearer $newToken';
              options.headers['Accept'] = 'application/json';

              // ✅ كمل بالـ request الحالي من غير ما تدخل في loop
              return handler.next(options);
            } catch (e) {
              print("From Refresh Token Error ${e.toString()}");

              await TokenManager.clear();
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                Routes.loginRegisterTabSwitcher,
                (route) => false,
              );
              return;
            }
          } else {
            print("From Refresh Token Exp");
            await TokenManager.clear();
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              Routes.loginRegisterTabSwitcher,
              (route) => false,
            );
            return;
          }
        } else {
          options.headers['Authorization'] = 'Bearer ${TokenManager.token}';
          options.headers['Accept'] = 'application/json';
          handler.next(options);
        }
      },
    );
  }
}
