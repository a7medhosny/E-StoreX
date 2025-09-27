import 'package:ecommerce/features/auth/register/logic/cubit/register_cubit.dart';
import 'package:ecommerce/features/auth/register/ui/widgets/register_bloc_listener.dart';
import 'package:ecommerce/features/auth/register/ui/widgets/registertion_form.dart';
import 'package:ecommerce/features/auth/widgets/social_button.dart';
import 'package:ecommerce/features/auth/register/ui/widgets/register_button.dart';
import 'package:ecommerce/features/auth/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RegistertionForm(),
          SizedBox(height: 32.h),
          RegisterButton(
            onPressed: () {
              if (context
                  .read<RegisterCubit>()
                  .formKey
                  .currentState!
                  .validate()) {
                context.read<RegisterCubit>().registerUser();
              }
            },
          ),
          SizedBox(height: 16.h),
          SizedBox(height: 16.h),
          // _orDividerText(),
          // SizedBox(height: 16.h),
          // SocialButton(
          //   icon: Icons.g_mobiledata_outlined,
          //   label: 'Continue with Google',
          //   onPressed: (){},
          // ),
          // SizedBox(height: 16.h),
          // SocialButton(icon: Icons.facebook, label: 'Continue with Facebook'),
          RegisterBlocListener(),
        ],
      ),
    );
  }
}

_orDividerText() {
  return Text(
    'OR',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 14.sp, color: Colors.black),
  );
}
