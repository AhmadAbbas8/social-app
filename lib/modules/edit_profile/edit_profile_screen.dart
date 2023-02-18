import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/app_cubit/social_cubit.dart';
import 'package:social_app/layout/app_cubit/social_state.dart';
import '../../models/user_model.dart';
import '../../shared/components/default_form_field.dart';
import '../../shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        UserModel? userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;
        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit Profile',
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(IconBroken.Arrow___Left_2),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    SocialCubit.get(context).updateUserData(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                  },
                  child: Text(
                    'UPdate'.toUpperCase(),
                  )),
              const SizedBox(width: 15),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoading)
                    const LinearProgressIndicator(),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null
                                        ? NetworkImage(userModel.coverImage!)
                                        : FileImage(coverImage)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getCoverImage();
                                },
                                icon: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.red[300],
                                    child: const Icon(IconBroken.Camera)),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 58,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundImage: profileImage != null
                                    ? FileImage(profileImage) as ImageProvider
                                    : NetworkImage(userModel.image!),
                              ),
                              IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getProfileImage();
                                },
                                icon: const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blue,
                                    child: Icon(IconBroken.Camera)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: MaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .upLoadProfileImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                      );
                                    },
                                    child: const Text(
                                      'upload profile',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                                if (state is SocialUserUpdateLoading)
                                const SizedBox(height: 5),
                                if (state is SocialUserUpdateLoading)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        const SizedBox(width: 5),
                        if (SocialCubit.get(context).coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: MaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context).upLoadCoverImage(
                                          name: nameController.text, phone: phoneController.text,
                                          bio: bioController.text,
                                      );
                                    },
                                    child: const Text(
                                      'upload cover',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                                if (state is SocialUserUpdateLoading)
                                const SizedBox(height: 5),
                                if (state is SocialUserUpdateLoading)
                                const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    const SizedBox(height: 8),
                  CustomTextFormField(
                    textEditingController: nameController,
                    lable: 'Name',
                    prefixIcon: IconBroken.User,
                    hintText: '',
                    textInputType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextFormField(
                    textEditingController: bioController,
                    lable: 'Bio',
                    prefixIcon: IconBroken.Info_Circle,
                    hintText: '',
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextFormField(
                    textEditingController: phoneController,
                    lable: 'Phone',
                    prefixIcon: IconBroken.Call,
                    hintText: '',
                    textInputType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
