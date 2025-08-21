import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';

class TextBtn extends StatelessWidget {
  const TextBtn(
      {super.key, this.onTap, required this.text, required this.enable});

  final VoidCallback? onTap;
  final String text;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enable ? MyColor.primary : MyColor.grey100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text,
            style: MyTypo.button
                .copyWith(color: enable ? MyColor.white : MyColor.grey300)),
      ),
    );
  }
}
