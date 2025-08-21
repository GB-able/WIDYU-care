import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.focusNode,
    this.maxLength,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.maxLines = 1,
    this.obscureText = false,
    this.inputAction = TextInputAction.done,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int? maxLength;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final Widget? suffix;
  final bool obscureText;
  final TextInputAction inputAction;
  final bool enabled;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final BorderRadius _radius = BorderRadius.circular(7);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator:
          widget.validator != null ? (val) => widget.validator!(val) : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      obscureText: widget.obscureText,
      textInputAction: widget.inputAction,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: MyTypo.hint.copyWith(color: MyColor.grey300),
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        prefix: const SizedBox(width: 15),
        suffixIcon: widget.suffix == null
            ? const SizedBox(width: 15)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: widget.suffix,
              ),
        errorStyle: MyTypo.helper.copyWith(color: MyColor.red),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColor.grey300, width: 1),
          borderRadius: _radius,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColor.grey300, width: 1),
          borderRadius: _radius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColor.grey300, width: 1),
          borderRadius: _radius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColor.red, width: 1),
          borderRadius: _radius,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColor.red, width: 1),
          borderRadius: _radius,
        ),
        filled: true,
        fillColor: widget.enabled ? Colors.transparent : MyColor.grey300,
      ),
      style: MyTypo.hint
          .copyWith(color: widget.enabled ? MyColor.grey700 : MyColor.grey900),
      cursorColor: MyColor.grey900,
      enabled: widget.enabled,
    );
  }
}
