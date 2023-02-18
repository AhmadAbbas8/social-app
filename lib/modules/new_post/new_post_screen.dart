import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/app_cubit/social_cubit.dart';
import 'package:social_app/layout/app_cubit/social_state.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
   NewPostScreen({Key? key}) : super(key: key);
TextEditingController txtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Create Post',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  var now = DateTime.now();
                  if(SocialCubit.get(context).postImage==null)
                    {
                      SocialCubit.get(context).createPost(
                          date: now.toString(), txt: txtController.text,
                      );
                    }else
                      {
                        SocialCubit.get(context).uploadPostImage(txt: txtController.text , date: now.toString());
                      }
                },
                child: Text(
                  'Post'.toUpperCase(),
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is SocialCreatePostLoading)
                LinearProgressIndicator(),
                if(state is SocialCreatePostLoading)
                SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          'https://t3.ftcdn.net/jpg/05/61/66/82/240_F_561668260_BFPEjRyt4gvajazvYlTfEkMEjxyqzi4z.jpg'),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            'Ahmad Abbas',
                            style: TextStyle(
                              height: 1.4,
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
controller: txtController  ,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: false,
                        hintText: 'What is on your mind . . . '),
                  ),
                ),
                SizedBox(
                    height: 20
                ),
if(SocialCubit.get(context).postImage!=null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: FileImage(SocialCubit.get(context).postImage!)
                          as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                       SocialCubit.get(context).removePostImage();
                      },
                      icon: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.red[300],
                          child: Icon(Icons.close)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.Image),
                            SizedBox(width: 5),
                            Text('Add Photo'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('# tags'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
