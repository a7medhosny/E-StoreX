import 'package:ecommerce/core/DI/get_it.dart';
import 'package:ecommerce/core/helpers/token_helper.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/networking/dio_factory.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:ecommerce/features/basket/logic/cubit/basket_cubit.dart';
import 'package:ecommerce/features/layout/logic/nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginLoading) {
          _showLoadingDialog(context);
        } else if (state is LoginSuccess) {
          await _handleLoginSuccess(context, state);
        } else if (state is LoginFailure) {
          _handleLoginFailure(context, state.errorMessage);
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _handleLoginSuccess(
    BuildContext context,
    LoginSuccess state,
  ) async {
    final authResponse = state.authResponseModel;
    final userId = TokenHelper.extractUserId(authResponse.token ?? '');

    // حفظ بيانات الدخول
    await TokenManager.saveLoginData(
      token: authResponse.token ?? '',
      refreshToken: authResponse.refreshToken ?? '',
      expiration: authResponse.expiration ?? '',
      refreshTokenExpirationDateTime:
          authResponse.refreshTokenExpirationDateTime ?? '',
      userName: authResponse.userName ?? '',
      email: authResponse.email ?? '',
      userId: userId ?? '',
    );

    DioFactory.afterLoginInterceptor();
    if (TokenManager.guestId != null) {
      context.read<BasketCubit>().mergeBasketWithGuestBasket(
        guestId: TokenManager.guestId ?? '',
      );
    }
    context.read<NavCubit>().reset();

    // قفل Dialog اللودينج
    Navigator.of(context, rootNavigator: true).pop();

    // الانتقال للـ LayoutScreen
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.layoutScreen,
      (route) => false,
    );

    // تصفير الـ Controllers
    context.read<LoginCubit>().emailController.clear();
    context.read<LoginCubit>().passwordController.clear();
  }

  void _handleLoginFailure(BuildContext context, String errorMessage) {
    // قفل Dialog اللودينج
    Navigator.of(context, rootNavigator: true).pop();

    // عرض رسالة الخطأ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  }
}
