import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/widgets/icon_widget.dart';
import 'package:flutter/material.dart';

class CardEditBtn extends StatelessWidget {
  const CardEditBtn({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: MyColor.grey50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const IconWidget(
                icon: "edit", width: 18, height: 18, color: MyColor.grey700),
            Text(
              "수정하기",
              style: MyTypo.subTitle2.copyWith(color: MyColor.grey700),
            ),
          ],
        ),
      ),
    );
  }
}
