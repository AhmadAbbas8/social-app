import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/shared/network/local/shared_pref.dart';
import '../../shared/components/custom_text_button.dart';
import '../../shared/components/default_form_field.dart';
import '../../shared/components/methods.dart';
import '../register/register_screen.dart';
import 'cubit/shop_login_cubit.dart';
import 'cubit/shop_login_state.dart';

class SocialLoginScreen extends StatelessWidget {
  SocialLoginScreen({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginState>(
        listener: (context, state) {
          if (state is SocialLoginError) {
            showFlutterToast(msg: state.error);
          } else if (state is SocialLoginSuccess) {
            showFlutterToast(msg: 'Success');
            SharedPref.saveData(key: 'uId', value: state.uId).then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SocialLayout(),
                  ),
                  (route) => false);
            });
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
                        Text('Login'.toUpperCase(),
                            style: Theme.of(context).textTheme.headline6),
                        Text('Login now to communicate with your friends',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.grey,
                                    )),
                        SizedBox(height: 30.0),
                        CustomTextFormField(
                          textEditingController: emailController,
                          prefixIcon: Icons.email,
                          lable: ('Email Adrdees'),
                          hintText: 'Enter your Email Address',
                        ),
                        SizedBox(height: 30),
                        CustomTextFormField(
                          obsecure:
                              SocialLoginCubit.get(context).isPasswordShow,
                          textEditingController: passwordController,
                          prefixIcon: Icons.key,
                          lable: 'Password',
                          hintText: 'Enter your password',
                          sufixIcon: SocialLoginCubit.get(context).suffix,
                          sufixFun: SocialLoginCubit.get(context)
                              .changePasswordVisibility,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              print('*******${emailController.text}');
                              print('*******${passwordController.text}');
                            }
                          },
                        ),
                        SizedBox(height: 30),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoading,
                          builder: (context) => CustomTextButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );

                                print('*******${emailController.text}');
                                print('*******${passwordController.text}');
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(),
                                      ));
                                },
                                child: Text('register'.toUpperCase()))
                          ],
                        )
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
