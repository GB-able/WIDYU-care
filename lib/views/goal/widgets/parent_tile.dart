import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/widgets/profile_widget.dart';
import 'package:flutter/material.dart';

class ParentTile extends StatelessWidget {
  const ParentTile(
      {super.key,
      required this.profileImage,
      required this.name,
      required this.isSelected});

  final String? profileImage;
  final String name;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: isSelected ? MyColor.primary : MyColor.grey100,
      ),
      child: Row(
        spacing: 4,
        children: [
          ProfileWidget(profileImage: profileImage, size: 36),
          Text(
            "$name 님",
            style: MyTypo.subTitle3.copyWith(
              color: isSelected ? MyColor.white : MyColor.grey700,
            ),
          ),
        ],
      ),
    );
  }
}
