import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/networking/dio_factory.dart';
import 'package:ecommerce/features/profile/data/models/profile_response_model.dart';
import 'package:ecommerce/features/profile/data/models/update_profile_request.dart';
import 'package:ecommerce/features/profile/data/repo/profile_repo.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.profileRepo) : super(ProfileInitial());
  final ProfileRepo profileRepo;

  Future<void> getUserProfile() async {
    emit(GetUserProfileLoading());
    try {
      final profile = await profileRepo.getUserProfile();
      emit(GetUserProfileSuccess(profile: profile));
    } catch (e) {
      emit(GetUserProfileError(error: e.toString()));
    }
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? phoneNumber,
    String? currentPassword,
    String? newPassword,
    String? confirmNewPassword,
  }) async {
    emit(UpdateUserProfileLoading());
    try {
      final response = await profileRepo.updateUserProfile(
        UpdateProfileRequest(
          userId: TokenManager.userId,
          displayName: displayName,
          phoneNumber: phoneNumber,
          currentPassword: currentPassword,
          newPassword: newPassword,
          confirmNewPassword: confirmNewPassword,
        ),
      );
      emit(UpdateUserProfileSuccess(message: "Profile updated successfully"));
      await getUserProfile(); // Refresh profile after upload
    } catch (e) {
      emit(UpdateUserProfileError(error: e.toString()));
    }
  }

  Future<void> uploadUserPhoto(String filePath) async {
    emit(UploadUserPhotoLoading());
    try {
      final file = File(filePath);
      final response = await profileRepo.uploadUserPhoto(file);

      emit(UploadUserPhotoSuccess(message: "Photo uploaded successfully"));
      await getUserProfile(); // Refresh profile after upload
    } catch (e) {
      emit(UploadUserPhotoError(error: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final response = await profileRepo.logout();

      emit(LogoutSuccess(message: "Logged out successfully"));

      await TokenManager.clear();
      DioFactory.removeAuthInterceptor();
    } catch (e) {
      emit(LogoutError(error: e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    try {
      final response = await profileRepo.deleteAccount();

      emit(DeleteAccountSuccess(message: "Deleted Account successfully"));

      await TokenManager.clear();
      DioFactory.removeAuthInterceptor();
    } catch (e) {
      emit(DeleteAccountError(error: e.toString()));
    }
  }
}
