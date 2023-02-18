import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login_screen/cubit/shop_login_state.dart';

class SocialLoginCubit extends Cubit<SocialLoginState> {
  SocialLoginCubit() : super(SocialLoginInitial());

  static SocialLoginCubit get(context) => BlocProvider.of(context);
  IconData suffix = Icons.visibility;
  bool isPasswordShow = true;

  void userLogin({required String email, required String password}) {
    emit(SocialLoginLoading());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          print(value.user!.uid);
      emit(SocialLoginSuccess(value.user!.uid));
    }).catchError((onError) {
      print(onError.code);
      emit(SocialLoginError(onError.code));
    });
  }

  void changePasswordVisibility() {
    isPasswordShow = !isPasswordShow;
    suffix = isPasswordShow ? Icons.visibility : Icons.visibility_off;
    emit(SocialChangePassword());
  }
}
