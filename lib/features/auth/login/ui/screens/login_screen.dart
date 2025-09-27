import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/auth/login/data/repo/login_repo.dart';
import 'package:ecommerce/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:ecommerce/features/auth/login/ui/screens/google_login_screen.dart';
import 'package:ecommerce/features/auth/login/ui/widgets/login_bloc_listener.dart';
import 'package:ecommerce/features/auth/login/ui/widgets/login_form.dart';
import 'package:ecommerce/features/auth/login/ui/widgets/sign_in_button.dart';
import 'package:ecommerce/features/auth/widgets/social_button.dart';
import 'package:ecommerce/features/auth/widgets/custom_text_field.dart';
import 'package:ecommerce/features/layout/logic/nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoginForm(),
          SizedBox(height: 32.h),
          SignInButton(
            onPressed: () {
              if (context.read<LoginCubit>().formKey.currentState!.validate()) {
                context.read<LoginCubit>().loginUser();
              }
            },
          ),
          SizedBox(height: 16.h),
          // _forgotPasswordText(),
          SizedBox(height: 16.h),
          _orDividerText(),
          // SizedBox(height: 16.h),
          SocialButton(
            icon: Icons.g_mobiledata_outlined,
            label: 'Continue with Google',
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const GoogleLoginScreen()),
              );

              if (result == true && context.mounted) {
                context.read<NavCubit>().reset();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.layoutScreen,
                  (route) => false,
                );
              }

              if (result == true && context.mounted) {
                print("Login with google succeeded");
                context.read<NavCubit>().reset();

                Future.microtask(() {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.layoutScreen,
                    (route) => false,
                  );
                });
              }
            },
          ),

          // SizedBox(height: 16.h),
          // SocialButton(icon: Icons.facebook, label: 'Continue with Facebook'),
          LoginBlocListener(),
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

_forgotPasswordText() {
  return GestureDetector(
    onTap: () {},
    child: Text(
      'Forgot Password?',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14.sp,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
