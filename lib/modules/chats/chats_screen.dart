import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/app_cubit/social_cubit.dart';
import 'package:social_app/models/user_model.dart';

import '../../layout/app_cubit/social_state.dart';
import '../chat_det/chat_det_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return ConditionalBuilder(
            condition: SocialCubit.get(context).users.isNotEmpty,
            builder: (context) => ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => buildChatItem(
                    context, SocialCubit.get(context).users[index]),
                separatorBuilder: (context, index) => const Divider(
                      thickness: 2,
                      height: 20,
                    ),
                itemCount: SocialCubit.get(context).users.length),
            fallback: (context) => const Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget buildChatItem(BuildContext context, UserModel model) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatDetScreen(model)));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(model.image!),
            ),
            const SizedBox(width: 15),
            Text(
              model.name!,
              style:
                  Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
