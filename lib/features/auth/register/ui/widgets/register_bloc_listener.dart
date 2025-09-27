import 'package:ecommerce/features/auth/register/logic/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBlocListener extends StatelessWidget {
  const RegisterBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          final authResponse = state.authResponse;
          final message = authResponse.message ?? 'Registration successful';
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          context.read<RegisterCubit>().passwordController.clear();
          context.read<RegisterCubit>().phoneController.clear();
          context.read<RegisterCubit>().nameController.clear();
          context.read<RegisterCubit>().passwordConfirmationController.clear();
          context.read<RegisterCubit>().emailController.clear();
          // Navigate to another screen or perform other actions
        } else if (state is RegisterFailure) {
          final errorMessage = state.errorMessage;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      },
      child: const SizedBox.shrink(), // Placeholder for the widget tree
    );
  }
}
