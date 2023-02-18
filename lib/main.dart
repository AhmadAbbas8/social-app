import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/app_cubit/social_cubit.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/components/methods.dart';
import 'package:social_app/shared/network/local/shared_pref.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'bolc_observer.dart';
import 'modules/login_screen/login_screen.dart';

Future<void> firebaseMessageBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  showFlutterToast(msg: 'firebaseMessageBackgroundHandler');
  print('object');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  print(token);
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    showFlutterToast(msg: 'onMessage');
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showFlutterToast(msg: 'on Message Opened App');
    //  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(),));
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessageBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await SharedPref.init();
  //SharedPref.removeData(key: 'uId');
  uId = SharedPref.getDataString(key: 'uId');

  runApp(
    SocialApp(),
  );
}

class SocialApp extends StatelessWidget {
  SocialApp();

  Widget startWidget = SocialLoginScreen();

  @override
  Widget build(BuildContext context) {
    startWidget = choseStartWidget();

    return BlocProvider(
      create: (context) => SocialCubit()
        ..getUserData()
        ..getPosts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        // darkTheme: darkTheme,
        home: startWidget,
      ),
    );
  }
}

Widget choseStartWidget() {
  String? uId = SharedPref.getDataString(key: 'uId');
  Widget? widget;
  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }
  return widget;
}
