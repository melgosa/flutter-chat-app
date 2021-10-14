import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData? icon;
  final String? placeHolder;
  final TextEditingController? textController;
  final TextInputType? textInputType;
  final bool isPassword;

  const CustomInput(
      {Key? key,
      @required this.icon,
      @required this.placeHolder,
      @required this.textController,
      this.textInputType = TextInputType.text,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 5),
                  blurRadius: 5)
            ]),
        child: TextField(
          obscureText: this.isPassword,
          controller: this.textController,
          autocorrect: false,
          keyboardType: this.textInputType,
          decoration: InputDecoration(
              prefixIcon: Icon(this.icon),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: this.placeHolder),
        ));
  }
}
