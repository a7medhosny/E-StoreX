import 'package:ecommerce/features/auth/widgets/custom_text_field.dart';
import 'package:ecommerce/features/profile/logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password", style: TextStyle(fontSize: 16.sp)),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UpdateUserProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: TextStyle(fontSize: 12.sp)),
              ),
            );
            Navigator.pop(context);
          }
          if (state is UpdateUserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error, style: TextStyle(fontSize: 12.sp)),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is UpdateUserProfileLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    labelText: "Current Password",
                    controller: currentPasswordController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter current password"
                                : null,
                  ),
                  verticalSpace(16),
                  CustomTextField(
                    labelText: "New Password",
                    controller: newPasswordController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter new password"
                                : null,
                  ),
                  verticalSpace(16),
                  CustomTextField(
                    labelText: "Confirm New Password",
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm your new password";
                      }
                      if (value != newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  verticalSpace(24),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                if (formKey.currentState!.validate()) {
                                  context
                                      .read<ProfileCubit>()
                                      .updateUserProfile(
                                        currentPassword:
                                            currentPasswordController.text,
                                        newPassword: newPasswordController.text,
                                        confirmNewPassword:
                                            confirmPasswordController.text,
                                      );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child:
                          isLoading
                              ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                "Update Password",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
