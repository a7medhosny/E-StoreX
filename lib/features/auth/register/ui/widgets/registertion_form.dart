import 'package:ecommerce/core/helpers/app_regex.dart';
import 'package:ecommerce/features/auth/register/logic/cubit/register_cubit.dart';
import 'package:ecommerce/features/auth/register/ui/widgets/password_validations.dart';
import 'package:ecommerce/features/auth/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistertionForm extends StatefulWidget {
  const RegistertionForm({super.key});

  @override
  State<RegistertionForm> createState() => _RegistertionFormState();
}

class _RegistertionFormState extends State<RegistertionForm> {
  bool isPasswordObscureText = true;
  bool isPasswordConfirmationObscureText = true;

  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;

  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = context.read<RegisterCubit>().passwordController;
    setupPasswordControllerListener();
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasLowercase = AppRegex.hasLowerCase(passwordController.text);
        hasUppercase = AppRegex.hasUpperCase(passwordController.text);
        hasSpecialCharacters = AppRegex.hasSpecialCharacter(
          passwordController.text,
        );
        hasNumber = AppRegex.hasNumber(passwordController.text);
        hasMinLength = AppRegex.hasMinLength(passwordController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<RegisterCubit>().formKey,
      child: Column(
        children: [
          CustomTextField(
            labelText: 'Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid name';
              }
            },
            controller: context.read<RegisterCubit>().nameController,
          ),
          SizedBox(height: 18),
          CustomTextField(
            labelText: 'Phone number',
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !AppRegex.isPhoneNumberValid(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            controller: context.read<RegisterCubit>().phoneController,
          ),
          SizedBox(height: 18),
          CustomTextField(
            labelText: 'Email',
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !AppRegex.isEmailValid(value)) {
                return 'Please enter a valid email';
              }
            },
            controller: context.read<RegisterCubit>().emailController,
          ),
          SizedBox(height: 18),
          CustomTextField(
            controller: context.read<RegisterCubit>().passwordController,
            labelText: 'Password',

            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !AppRegex.isPasswordValid(value)) {
                return 'Please enter a valid password';
              }
            },
          ),
          SizedBox(height: 18),
          CustomTextField(
            controller:
                context.read<RegisterCubit>().passwordConfirmationController,
            labelText: 'Password Confirmation',

            validator: (value) {
              if (value == null ||
                  value.isEmpty )
                   {
                return 'Please enter a valid password';
              }
              else if (value !=
                  context.read<RegisterCubit>().passwordController.text) {
                return 'Passwords do not match';
              }
            },
          ),
          SizedBox(height: 24),
          PasswordValidations(
            hasLowerCase: hasLowercase,
            hasUpperCase: hasUppercase,
            hasSpecialCharacters: hasSpecialCharacters,
            hasNumber: hasNumber,
            hasMinLength: hasMinLength,
          ),
        ],
      ),
    );
  }
}
