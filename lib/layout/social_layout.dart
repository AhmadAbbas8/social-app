import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/app_cubit/social_state.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/shared/components/methods.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../models/user_model.dart';
import 'app_cubit/social_cubit.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SocialNewPost) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewPostScreen(),
              ));
        }
      },
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(IconBroken.Notification)),
              IconButton(onPressed: () {}, icon: const Icon(IconBroken.Search)),
            ],
          ),
          body: cubit.layoutScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (value) {
              cubit.changeBottomNav(value);
            },
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(IconBroken.Home),
              ),
              BottomNavigationBarItem(
                label: 'Chat',
                icon: Icon(IconBroken.Chat),
              ),
              BottomNavigationBarItem(
                label: 'Post',
                icon: Icon(IconBroken.Paper_Upload),
              ),
              BottomNavigationBarItem(
                label: 'Users',
                icon: Icon(IconBroken.User1),
              ),
              BottomNavigationBarItem(
                label: 'Setting',
                icon: Icon(
                  IconBroken.Setting,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ConditionalBuilder buildConditionalBuilderForTestAndJustTryVerification(
      BuildContext context) {
    return ConditionalBuilder(
      fallback: (context) => const Center(child: CircularProgressIndicator()),
      builder: (context) {
        UserModel model = SocialCubit.get(context).userModel!;
        return Column(
          children: [
            if (!FirebaseAuth.instance.currentUser!.emailVerified)
              Container(
                color: Colors.amber.withOpacity(0.6),
                height: 50.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text('Please verify your email'),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.currentUser!
                              .sendEmailVerification()
                              .then((value) {
                            showFlutterToast(msg: 'Check your email');
                          }).catchError((onError) {
                            print(onError.toString());
                          });
                        },
                        child: const Text(
                          'Send email verification',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
      condition: SocialCubit.get(context).userModel != null,
    );
  }
}
