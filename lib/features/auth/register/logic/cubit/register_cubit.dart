import 'package:bloc/bloc.dart';
import 'package:ecommerce/features/auth/login/data/models/auth_response_model.dart';
import 'package:ecommerce/features/auth/register/data/models/register_request_model.dart';
import 'package:ecommerce/features/auth/register/data/repo/register_repo.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this.registerRepo}) : super(RegisterInitial());

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RegisterRepo registerRepo;
  Future<void> registerUser() async {
    emit(RegisterLoading());
    try {
      final authResponse = await registerRepo.register(
        RegisterRequestModel(
          userName: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          password: passwordController.text,
          confirmPassword: passwordConfirmationController.text,
        ),
      );
      emit(RegisterSuccess(authResponse));
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(RegisterFailure(errorMessage));
    }
  }
}
