import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  String? txt;
  VoidCallback? function;
  double? high, width;

  CustomTextButton({
    required this.txt,
    this.width,
    this.high,
    @required this.function,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: high,
      child: TextButton(
        onPressed: function,
        child: Text(
          txt!,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.blue,
          ),
          shape: MaterialStateProperty.all(StadiumBorder()),
        ),
      ),
    );
  }
}
