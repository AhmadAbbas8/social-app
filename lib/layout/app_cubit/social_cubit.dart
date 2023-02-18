import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/user_screen.dart';
import '../../modules/chats/chats_screen.dart';
import '../../shared/components/constants.dart';
import 'social_state.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitial());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoading());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(json: value.data()!);
      emit(SocialGetUserSuccess());
    }).catchError((onError) {
      emit(SocialGetUserError(onError.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> layoutScreens = [
    const FeedsScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen(),
  ];

  void changeBottomNav(index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(SocialNewPost());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNav());
    }
  }

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  File? profileImage;

  final ImagePicker picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    String path = pickedFile!.path;
    if (pickedFile != null) {
      profileImage = File(path);
      emit(SocialProfileImagePickedSuccess());
    } else {
      emit(SocialProfileImagePickedError());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    String path = pickedFile!.path;
    if (pickedFile != null) {
      coverImage = File(path);
      emit(SocialCoverImagePickedSuccess());
    } else {
      emit(SocialCoverImagePickedError());
    }
  }

  ///data/user/0/com.example.social_app/cache/image_picker1072816584825374875.jpg

  String profileImageUrl = '';

  void upLoadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoading());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserData(
          bio: bio,
          name: name,
          phone: phone,
          image: value,
        );
        profileImageUrl = value;
        emit(SocialUploadProfileImagePickedSuccess());
      }).catchError((onError) {
        emit(SocialUploadProfileImagePickedError());
        if (kDebugMode) {
          print('second error ${onError.toString()}');
        }
      });
    }).catchError((onError) {
      emit(SocialUploadProfileImagePickedError());
    });
  }

  String coverImageUrl = '';

  void upLoadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoading());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        // emit(SocialUploadCoverImagePickedSuccess());
        updateUserData(
          bio: bio,
          name: name,
          phone: phone,
          cover: value,
        );
      }).catchError((onError) {
        emit(SocialUploadCoverImagePickedError());
      });
    }).catchError((onError) {
      emit(SocialUploadCoverImagePickedError());
    });
  }

  //
  // void updateUser({
  //   required String name,
  //   required String phone,
  //   required String bio,
  //   String? cover ,
  //   String? image ,
  //
  //
  // }) {
  //   UserModel model = UserModel(
  //     name: name,
  //     phone: phone,
  //     isEmailVerified: false,
  //     bio: bio,
  //     coverImage: cover??userModel!.coverImage!,
  //     image:image?? userModel!.image!,
  //     uId: userModel!.uId!,
  //     email: userModel!.email!,
  //   );
  //   emit(SocialUserUpdateLoading());
  //   if (coverImage != null) {
  //     upLoadCoverImage();
  //   } else if (profileImage != null) {
  //     upLoadProfileImage();
  //   }
  //   else if (coverImage != null && profileImage != null)
  //   {
  //
  //   } else {
  //     updateUserData(
  //       phone: phone,
  //       name: name,
  //       bio: bio,
  //     );
  //   }
  //
  // }

  void updateUserData({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    emit(SocialUserUpdateLoading());
    UserModel model = UserModel(
      name: name,
      phone: phone,
      isEmailVerified: false,
      bio: bio,
      coverImage: cover ?? userModel!.coverImage!,
      image: image ?? userModel!.image!,
      uId: userModel!.uId!,
      email: userModel!.email!,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId!)
        .update(model.toJson())
        .then((value) {
      // emit(SocialUserUpdateSuccess());
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateError());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    String path = pickedFile!.path;
    if (pickedFile != null) {
      postImage = File(path);
      emit(SocialPostImagePickedSuccess());
    } else {
      emit(SocialPostImagePickedError());
    }
  }

  void uploadPostImage({
    required String txt,
    required String date,
  }) {
    emit(SocialCreatePostLoading());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(date: date, txt: txt, postImage: value);
      }).catchError((onError) {
        emit(SocialCreatePostError(onError.toString()));
      });
    }).catchError((onError) {
      emit(SocialCreatePostError(onError.toString()));
    });
  }

  void createPost({
    required String date,
    required String txt,
    String? postImage,
  }) {
    emit(SocialCreatePostLoading());
    PostModel model = PostModel(
      name: userModel!.name!,
      image: userModel!.image!,
      uId: userModel!.uId!,
      date: date,
      txt: txt,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toJson())
        .then((value) {
      emit(SocialCreatePostSuccess());
    }).catchError((error) {
      emit(SocialCreatePostError(error.toString()));
    });
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImagePickerSucces());
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> comments = [];

  void getPosts() {
    emit(SocialGetPostsLoading());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        value.docs.forEach((element) {
          element.reference.collection('comments').get().then((value) {
            comments.add(value.docs.length);
          }).catchError((onError) {});
        });
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(
            json: element.data(),
          ));
        }).catchError((onError) {});
      });
      emit(SocialGetPostsSuccess());
    }).catchError((onError) {
      emit(SocialGetPostsError(onError.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccess());
    }).catchError((onError) {
      emit(SocialLikePostError(onError.toString()));
    });
  }

  void commentPost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel!.uId)
        .set({
      'comment': true,
    }).then((value) {
      emit(SocialCommentPostSuccess());
    }).catchError((error) {
      emit(SocialCommentPostError(error.toString()));
    });
  }

  List<UserModel> users = [];

  void getAllUsers() {
    users.clear();
    emit(SocialGetAllUsersLoading());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] != userModel!.uId) {
          users.add(UserModel.fromJson(json: element.data()));
        }
      });
      emit(SocialGetAllUsersSuccess());
    }).catchError((onError) {
      emit(SocialGetAllUsersError(onError.toString()));
    });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String txt,
  }) {
    MessageModel model = MessageModel(
      txt: txt,
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(SocialSendMessageSuccess());
    }).catchError((onError) {
      emit(SocialSendMessageError(onError.toString()));
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(SocialSendMessageSuccess());
    }).catchError((onError) {
      emit(SocialSendMessageError(onError.toString()));
    });
  }

  List<MessageModel> messages = [];

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages.clear();
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(json: element.data()));
      }
      emit(SocialGetMessagesSuccess());
    });
  }
}
