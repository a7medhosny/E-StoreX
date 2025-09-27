import 'package:ecommerce/core/helpers/app_regex.dart';
import 'package:ecommerce/core/helpers/spacing.dart';
import 'package:ecommerce/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:ecommerce/features/auth/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            labelText: 'Email Address',
            controller: cubit.emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }

              if (!AppRegex.isEmailValid(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          verticalSpace(16),
          CustomTextField(
            labelText: 'Password',
            controller: cubit.passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          verticalSpace(16),
          Row(
            children: [
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return Checkbox(
                    value: cubit.rememberMe,
                    onChanged: (value) {
                      setState(() {
                        cubit.rememberMe = value ?? false;
                      });
                    },
                  );
                },
              ),
              const Text('Remember Me'),
            ],
          ),
        ],
      ),
    );
  }
}
