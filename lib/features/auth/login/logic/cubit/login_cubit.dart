import 'package:bloc/bloc.dart';
import 'package:ecommerce/features/auth/login/data/models/auth_response_model.dart';
import 'package:ecommerce/features/auth/login/data/models/login_request_model.dart';
import 'package:ecommerce/features/auth/login/data/repo/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginRepo}) : super(LoginInitial());
  final LoginRepo loginRepo;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  Future<void> loginUser() async {
    emit(LoginLoading());
    try {
      AuthResponseModel authResponse = await loginRepo.login(
        LoginRequestModel(
          email: emailController.text,
          password: passwordController.text,
          rememberMe: rememberMe,
        ),
      );
      emit(LoginSuccess(authResponseModel: authResponse));
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      print(errorMessage);

      emit(LoginFailure(errorMessage));
    }
  }

  Future<void> externalLogin({required String provider}) async {
    emit(LoginLoading());
    try {
      AuthResponseModel authResponse = await loginRepo.externalLogin(
        provider: provider,
      );
      emit(LoginSuccess(authResponseModel: authResponse));
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      print(errorMessage);

      emit(LoginFailure(errorMessage));
    }
  }

  Future<void> resetPassword({
    required String userId,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      AuthResponseModel authResponse = await loginRepo.resetPassword(
        userId: userId,
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      emit(ResetPasswordSuccess(authResponseModel: authResponse));
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(ResetPasswordFailure(errorMessage));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(ForgotPasswordLoading());
    try {
      AuthResponseModel authResponseModel = await loginRepo.forgotPassword(
        email: email,
      );
      emit(ForgotPasswordSuccess(authResponseModel: authResponseModel));
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(ForgotPasswordFailure(errorMessage));
    }
  }
}
