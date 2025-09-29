import 'dart:io';
import 'package:ecommerce/core/helpers/image_url.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/profile/logic/cubit/profile_cubit.dart';
import 'package:ecommerce/features/profile/ui/widgets/draw_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/features/profile/data/models/profile_response_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce/core/helpers/spacing.dart'; // هنا مكان verticalSpace و horizontalSpace

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    if (TokenManager.token != null) {
      context.read<ProfileCubit>().getUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = TokenManager.token;
    if (token == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Profile"), centerTitle: true),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 80.sp, color: Colors.grey),
                verticalSpace(20),
                Text(
                  "You are browsing as a guest.",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                verticalSpace(10),
                Text(
                  "Sign in or create an account to view your profile, track orders, and use coupons.",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                verticalSpace(30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.loginRegisterTabSwitcher,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: const Text("Login"),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.loginRegisterTabSwitcher,
                            arguments: false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: const Text("Register"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is UploadUserPhotoSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is LogoutLoading || state is DeleteAccountLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        }

        // لو Success
        if (state is LogoutSuccess || state is DeleteAccountSuccess) {
          if (Navigator.canPop(context)) Navigator.pop(context); // يقفل اللودنج

          final message =
              state is LogoutSuccess
                  ? state.message
                  : (state as DeleteAccountSuccess).message;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));

          Navigator.pushReplacementNamed(
            context,
            Routes.loginRegisterTabSwitcher,
          );
        }

        // لو Error
        if (state is LogoutError || state is DeleteAccountError) {
          if (Navigator.canPop(context)) Navigator.pop(context);

          final error =
              state is LogoutError
                  ? state.error
                  : (state as DeleteAccountError).error;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
        }
      },
      buildWhen:
          (previous, current) =>
              current is GetUserProfileError ||
              current is GetUserProfileSuccess ||
              current is GetUserProfileLoading,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("My Profile"),
            centerTitle: true,
            automaticallyImplyLeading: state is GetUserProfileSuccess,
          ),
          drawer:
              state is GetUserProfileSuccess
                  ? _buildDrawer(context, state.profile)
                  : null,
          body: () {
            if (state is GetUserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetUserProfileError) {
              return Center(child: Text("Error: ${state.error}"));
            } else if (state is GetUserProfileSuccess) {
              final profile = state.profile;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60.r,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage:
                              (profile.photoUrl != null &&
                                      profile.photoUrl!.isNotEmpty)
                                  ? NetworkImage(
                                    ImageUrl.getValidUrl(profile.photoUrl!),
                                  )
                                  : null,
                          child:
                              (profile.photoUrl == null ||
                                      profile.photoUrl!.isEmpty)
                                  ? Icon(
                                    Icons.person,
                                    size: 60.sp,
                                    color: Colors.white,
                                  )
                                  : null,
                        ),
                        InkWell(
                          onTap: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              context.read<ProfileCubit>().uploadUserPhoto(
                                pickedFile.path,
                              );
                            }
                          },
                          child: CircleAvatar(
                            radius: 20.r,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.camera_alt,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(30),
                    Text(
                      profile.displayName ?? "No Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    verticalSpace(5),
                    Text(
                      profile.email ?? "No Email",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    verticalSpace(20),
                    _buildInfoCard(
                      Icons.phone,
                      profile.phoneNumber ?? "No Phone",
                    ),
                    _buildInfoCard(
                      Icons.verified_user,
                      profile.isActive == true ? "Account Active" : "Inactive",
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text("No profile data"));
          }(),
        );
      },
    );
  }

  Widget _buildInfoCard(IconData icon, String text) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ListTile(
        leading: Icon(icon),
        title: Text(text, style: TextStyle(fontSize: 14.sp)),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, ProfileResponseModel profile) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              profile.displayName ?? "No Name",
              style: TextStyle(fontSize: 16.sp),
            ),
            accountEmail: Text(
              profile.email ?? "",
              style: TextStyle(fontSize: 14.sp),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  (profile.photoUrl != null && profile.photoUrl!.isNotEmpty)
                      ? NetworkImage(ImageUrl.getValidUrl(profile.photoUrl!))
                      : null,
              child:
                  (profile.photoUrl == null || profile.photoUrl!.isEmpty)
                      ? Icon(Icons.person, size: 40.sp, color: Colors.white)
                      : null,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.grey.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          DrawerItem(
            icon: Icons.shopping_bag,
            title: "My Orders",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.ordersScreen);
            },
          ),
          DrawerItem(
            icon: Icons.lock_reset,
            title: "Change Password",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.resetPassword);
            },
          ),
          const Divider(),
          DrawerItem(
            icon: Icons.logout,
            title: "Logout",
            onTap: () {
              Navigator.pop(context);
              context.read<ProfileCubit>().logout();
            },
          ),
          DrawerItem(
            icon: Icons.delete_forever,
            title: "Delete Account",
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmDialog(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();

    return showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Delete Account"),
            content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // cancel
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  cubit.deleteAccount();
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }
}
