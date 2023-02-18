import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/app_cubit/social_state.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../../layout/app_cubit/social_cubit.dart';
import '../../models/message_model.dart';

class ChatDetScreen extends StatelessWidget {
  ChatDetScreen(this.userModel);

  TextEditingController _msgController = TextEditingController();
  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessages(receiverId: userModel!.uId!);
      return BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(userModel!.image!),
                  ),
                  const SizedBox(width: 11),
                  Text(
                    userModel!.name!,
                  ),
                ],
              ),
            ),
            body: ConditionalBuilder(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            var msg = SocialCubit.get(context).messages[index];
                            if (SocialCubit.get(context).userModel!.uId! ==
                                msg.senderId) return buildMyMessage(msg);
                            return buildAnotherMessage(msg);
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10),
                          itemCount: SocialCubit.get(context).messages.length),
                    ),
                    const Spacer(),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300]!, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: _msgController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type a message . . .'),
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            color: defaultColor.withOpacity(0.78),
                            child: MaterialButton(
                              minWidth: 1,
                              onPressed: () {
                                SocialCubit.get(context).sendMessage(
                                  receiverId: userModel!.uId!,
                                  dateTime: DateTime.now().toString(),
                                  txt: _msgController.text,
                                );
                                _msgController.clear();
                              },
                              child: const Icon(
                                IconBroken.Send,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              fallback: (context) => Center(
                  child: Text(
                'No Message Yet 😴😴',
                style: Theme.of(context).textTheme.subtitle2,
              )),
              condition: SocialCubit.get(context).messages.isNotEmpty,
            ),
          );
        },
      );
    });
  }

  Widget buildMyMessage(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
            color: defaultColor.withOpacity(.2),
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
            )),
        child:  Text(
          model.txt!,
        ),
      ),
    );
  }

  Widget buildAnotherMessage(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
            )),
        child:  Text(
          model.txt!,
        ),
      ),
    );
  }
}
