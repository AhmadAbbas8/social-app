
abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialGetUserSuccess extends SocialState {}
class SocialGetUserError extends SocialState {
  final String error ;

  SocialGetUserError(this.error);
}
class SocialGetUserLoading extends SocialState {}

class SocialChangeBottomNav extends SocialState{}
class SocialNewPost extends SocialState{}

class SocialProfileImagePickedSuccess extends SocialState{}
class SocialProfileImagePickedError extends SocialState{}

class SocialCoverImagePickedSuccess extends SocialState{}
class SocialCoverImagePickedError extends SocialState{}

class SocialUploadCoverImagePickedSuccess extends SocialState{}
class SocialUploadCoverImagePickedError extends SocialState{}


class SocialUploadProfileImagePickedSuccess extends SocialState{}
class SocialUploadProfileImagePickedError extends SocialState{}

class SocialUserUpdateError extends SocialState{}
class SocialUserUpdateLoading extends SocialState{}
class SocialUserUpdateSuccess extends SocialState{}


 class SocialCreatePostLoading extends SocialState{}
 class SocialCreatePostSuccess extends SocialState{}
 class SocialCreatePostError extends SocialState{
  final String error;

  SocialCreatePostError(this.error);
 }



class SocialPostImagePickedSuccess extends SocialState{}
class SocialPostImagePickedError extends SocialState{}


class RemovePostImagePickerSucces extends SocialState{}



class SocialGetPostsLoading extends SocialState{}
class SocialGetPostsSuccess extends SocialState{}
class SocialGetPostsError extends SocialState{
  final String error;

  SocialGetPostsError(this.error);
}


class SocialLikePostSuccess extends SocialState{}
class SocialLikePostError extends SocialState{
  final String error ;

  SocialLikePostError(this.error);

}
class SocialCommentPostSuccess extends SocialState{}
class SocialCommentPostError extends SocialState{
  final String error ;

  SocialCommentPostError(this.error);

}



class SocialGetAllUsersSuccess extends SocialState {}
class SocialGetAllUsersError extends SocialState {
  final String error ;

  SocialGetAllUsersError(this.error);
}
class SocialGetAllUsersLoading extends SocialState {}

///////////////////////////////////////////////////

class SocialSendMessageSuccess extends SocialState{}
class SocialSendMessageError extends SocialState{
  final String error;

  SocialSendMessageError(this.error);
}


class SocialGetMessagesSuccess extends SocialState{}