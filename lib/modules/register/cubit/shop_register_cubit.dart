import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/shop_register_state.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterState> {
  SocialRegisterCubit() : super(SocialRegisterInitial());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);
  IconData suffix = Icons.visibility;
  bool isPasswordShow = true;

  void userRegister({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) {
    emit(SocialRegisterLoading());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      if (kDebugMode) {
        print(value.user!.email);
      }
      print(value.user!.email);
      userCreate(email: email, name: name, phone: phone, uId: value.user!.uid);

      // emit(SocialRegisterSuccess());
    }).catchError((onError) {
      print('************${onError.toString()}');
      emit(SocialRegisterError(onError.code));
    });
  }

  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,
  }) async {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      email: email,
      uId: uId,
      isEmailVerified: false,
      bio:'write your bio',
      coverImage: 'https://t4.ftcdn.net/jpg/02/77/11/13/240_F_277111357_AEHr3yYNFCLPYGfsVVDsUARHkLjGnEfn.jpg',
      image:
          'https://t3.ftcdn.net/jpg/05/61/66/82/240_F_561668260_BFPEjRyt4gvajazvYlTfEkMEjxyqzi4z.jpg',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toJson())
        .then((value) {
      emit(SocialCreateUserSuccess(uId));
    }).catchError((onError) {
      print('************${onError.toString()}');
      emit(SocialCreateUserError(onError.toString()));
    });
  }

  void changePasswordVisibility() {
    isPasswordShow = !isPasswordShow;
    suffix = isPasswordShow ? Icons.visibility : Icons.visibility_off;
    emit(SocialRegisterChangePassword());
  }
}
