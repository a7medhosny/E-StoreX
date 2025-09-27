part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class GetUserProfileLoading extends ProfileState {}
final class GetUserProfileSuccess extends ProfileState {
  final ProfileResponseModel profile;

  GetUserProfileSuccess({required this.profile});
}
final class GetUserProfileError extends ProfileState {
  final String error;
  GetUserProfileError({required this.error});
}

final class UpdateUserProfileLoading extends ProfileState {}
final class UpdateUserProfileSuccess extends ProfileState {
  final String message;

  UpdateUserProfileSuccess({required this.message});
}
final class UpdateUserProfileError extends ProfileState {
  final String error;
  UpdateUserProfileError({required this.error});
}

class UploadUserPhotoLoading extends ProfileState {}
class UploadUserPhotoSuccess extends ProfileState {
  final String message;
  UploadUserPhotoSuccess({required this.message});
}
class UploadUserPhotoError extends ProfileState {
  final String error;
  UploadUserPhotoError({required this.error});
}

// Logout States
class LogoutLoading extends ProfileState {}

class LogoutSuccess extends ProfileState {
  final String message;
  LogoutSuccess({required this.message});
}

class LogoutError extends ProfileState {
  final String error;
  LogoutError({required this.error});
}

class DeleteAccountLoading extends ProfileState {}

class DeleteAccountSuccess extends ProfileState {
  final String message;
  DeleteAccountSuccess({required this.message});
}

class DeleteAccountError extends ProfileState {
  final String error;
  DeleteAccountError({required this.error});
}


