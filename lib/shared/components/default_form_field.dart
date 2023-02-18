import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  String? hintText, lable;

  TextEditingController? textEditingController;
  IconData? prefixIcon, sufixIcon;
  final String? Function(String?)? onSubmit;
  bool? obsecure  ;
  VoidCallback? sufixFun ;
  TextInputType? textInputType;
  CustomTextFormField({super.key,
    required this.textEditingController,
    required this.prefixIcon,
    required this.lable,
    required this.hintText,
     this.sufixFun ,
    this.sufixIcon,
    this.onSubmit,
     this.obsecure = false,
    this.textInputType,
  });

  @override
  Widget build(context) {
    return TextFormField(
      keyboardType: textInputType,
      obscureText: obsecure!,
      onFieldSubmitted: onSubmit,
      controller: textEditingController,
      validator: (value) {
        if(value!.isEmpty) {
          return 'required field';
        }
        return null;
      },
      decoration: InputDecoration(
          label: Text(lable!),
          suffixIcon: IconButton(
            onPressed:sufixFun ,
            icon: Icon(sufixIcon),
          ),
          prefixIcon: Icon(prefixIcon!),
          hintText: hintText!,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )
      ),
    );
  }
}


