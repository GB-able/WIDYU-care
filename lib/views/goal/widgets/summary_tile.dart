import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  const SummaryTile(
      {super.key,
      required this.title,
      required this.value,
      required this.isCurrent});

  final String title;
  final String value;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: MyColor.grey50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Text(
            value,
            style: isCurrent
                ? MyTypo.title2.copyWith(color: MyColor.primary)
                : MyTypo.body1.copyWith(color: MyColor.grey500),
          ),
          Text(
            title,
            style: isCurrent
                ? MyTypo.subTitle2.copyWith(color: MyColor.grey900)
                : MyTypo.body2.copyWith(color: MyColor.grey600),
          ),
        ],
      ),
    );
  }
}
