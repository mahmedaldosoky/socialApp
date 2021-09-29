import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DefaultTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final Icon? prefixIcon;
  final TextInputType keyboardType;

  bool showPassword = false;

  DefaultTextField({
    required this.controller,
    this.hintText = "",
    this.labelText = "",
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  @override
  Widget build(BuildContext context) {
    bool isPassword = widget.hintText.toLowerCase() == "password" ||
            widget.labelText.toLowerCase() == "password"
        ? true
        : false;

    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: isPassword && !widget.showPassword,
      textAlign: TextAlign.start,
      decoration: new InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //border: InputBorder.none,
        border: new OutlineInputBorder(
          borderSide: new BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon ??
            Container(
              width: 0,
            ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.showPassword = !widget.showPassword;
                  });
                },
                icon: Icon(
                  widget.showPassword
                      ? Icons.visibility_off
                      : Icons.remove_red_eye_outlined,
                ),
              )
            : Container(
                width: 0,
              ),
      ),
    );
  }
}
