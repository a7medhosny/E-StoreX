import 'dart:convert';
import 'package:ecommerce/core/helpers/token_helper.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/networking/dio_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:ecommerce/features/basket/logic/cubit/basket_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loginWithGoogle();
  }

  Future<void> _loginWithGoogle() async {
    try {
      final result = await FlutterWebAuth2.authenticate(
        url:
            "https://estorex.runasp.net/api/v1/Account/external-login"
            "?provider=Google"
            "&platform=flutter"
            "&clientId=125e2213-8691-45e9-ab60-d4bfa1367428",
        callbackUrlScheme: "myapp",
      );

      // ✅ اطبع النتيجة الخام قبل أي parsing
      // debugPrint("🔗 Raw redirect result: $result");

      final uri = Uri.parse(result);
      // debugPrint("✅ Parsed URI: $uri");

      // ✅ استخرج القيم من الـ query parameters
      final token = uri.queryParameters['token'];
      final refresh = uri.queryParameters['refreshToken'];
      final expiration = uri.queryParameters['expiration'];
      final refreshExp = uri.queryParameters['refreshTokenExpirationDateTime'];
      final userName = uri.queryParameters['userName'];
      final email = uri.queryParameters['email'];

      // debugPrint("🟢 token: $token");
      // debugPrint("🟢 refreshToken: $refresh");
      // debugPrint("🟢 expiration: $expiration");
      // debugPrint("🟢 refreshTokenExpirationDateTime: $refreshExp");
      // debugPrint("🟢 userName: $userName");
      // debugPrint("🟢 email: $email");

      final userId = TokenHelper.extractUserId(token ?? '');
      // debugPrint("🟢 userId from token: $userId");

      // ✅ خزن البيانات
      await TokenManager.saveLoginData(
        token: token ?? '',
        refreshToken: refresh ?? '',
        expiration: expiration ?? '',
        refreshTokenExpirationDateTime: refreshExp ?? '',
        userName: userName ?? '',
        email: email ?? '',
        userId: userId ?? '',
      );

      // debugPrint("🎉 Google login success");

      DioFactory.afterLoginInterceptor();
      if (TokenManager.guestId != null) {
        context.read<BasketCubit>().mergeBasketWithGuestBasket(
          guestId: TokenManager.guestId ?? '',
        );
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e, st) {
      // debugPrint("❌ Google login error: $e");
      // debugPrint("❌ StackTrace: $st");
      if (mounted) Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
