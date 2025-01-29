import 'package:flutter/material.dart';

class Utils {
  static final RegExp emailFormat =
      RegExp(r'^(?=.{1,29}$)[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
}

bool dbIsReady = false;

TextStyle grayText = TextStyle(color: Colors.black45, fontSize: 15);

class Sw extends StatelessWidget {
  final double w;
  const Sw({super.key, this.w = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: w);
  }
}

class Sh extends StatelessWidget {
  final double h;
  const Sh({super.key, this.h = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: h);
  }
}

class Button extends StatelessWidget {
  final void Function()? press;
  final String text;
  final Color? bg;
  final Color? fg;

  const Button(
      {super.key,
      required this.press,
      required this.text,
      this.bg = Colors.blue,
      this.fg = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: press,
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(bg),
            foregroundColor: WidgetStatePropertyAll(fg),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))),
        child: Text(text));
  }
}
