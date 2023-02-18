import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/shared/components/methods.dart';
import 'package:social_app/shared/network/local/shared_pref.dart';
import '../../shared/components/custom_text_button.dart';
import '../../shared/components/default_form_field.dart';
import 'cubit/shop_register_cubit.dart';
import 'cubit/shop_register_state.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterState>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccess) {
            showFlutterToast(msg: 'User Created Successfully');
            SharedPref.saveData(key: 'uId', value: state.uId).then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SocialLayout(),
                  ),
                  (route) => false);
            });
          } else if (state is SocialRegisterError ||
              state is SocialCreateUserError) {
            showFlutterToast(msg: 'Try Again');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Register'.toUpperCase(),
                            style: Theme.of(context).textTheme.headline6),
                        Text('Login now to communicate with your friends',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.grey,
                                    )),
                        SizedBox(height: 30.0),
                        CustomTextFormField(
                          textEditingController: nameController,
                          prefixIcon: Icons.person,
                          lable: ('Name'),
                          hintText: 'Enter your Name',
                        ),
                        SizedBox(height: 30),
                        CustomTextFormField(
                          textEditingController: emailController,
                          prefixIcon: Icons.email,
                          lable: ('Email'),
                          hintText: 'Enter your Email',
                        ),
                        SizedBox(height: 30),
                        CustomTextFormField(
                          textEditingController: phoneController,
                          prefixIcon: Icons.phone,
                          lable: ('Phone'),
                          hintText: 'Enter your Phone',
                        ),
                        SizedBox(height: 30),
                        CustomTextFormField(
                          obsecure:
                              SocialRegisterCubit.get(context).isPasswordShow,
                          textEditingController: passwordController,
                          prefixIcon: Icons.key,
                          lable: 'Password',
                          hintText: 'Enter your Passwoed',
                          sufixIcon: SocialRegisterCubit.get(context).suffix,
                          sufixFun: SocialRegisterCubit.get(context)
                              .changePasswordVisibility,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              SocialRegisterCubit.get(context).userRegister(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                        ),
                        SizedBox(height: 30),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoading,
                          builder: (context) => CustomTextButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                  name: nameController.text,
                                );
                              }
                            },
                            txt: 'Login'.toUpperCase(),
                            width: MediaQuery.of(context).size.width,
                            high: 55,
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
