
abstract class SocialRegisterState {}

class SocialRegisterInitial extends SocialRegisterState {}

class SocialRegisterLoading extends SocialRegisterState {}
class SocialRegisterSuccess extends SocialRegisterState {}
class SocialRegisterError extends SocialRegisterState {
  final String error;
  SocialRegisterError(this.error);
}


class SocialCreateUserLoading extends SocialRegisterState {}
class SocialCreateUserSuccess extends SocialRegisterState {
  final String uId;

  SocialCreateUserSuccess(this.uId);
}
class SocialCreateUserError extends SocialRegisterState {
  final String error;
  SocialCreateUserError(this.error);
}
class SocialRegisterChangePassword extends SocialRegisterState {}
