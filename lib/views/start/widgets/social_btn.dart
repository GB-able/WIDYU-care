import 'package:care/models/enums/social_type.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialBtn extends StatelessWidget {
  const SocialBtn({super.key, required this.onTap, required this.type});

  final VoidCallback onTap;
  final SocialType type;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: type.color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          children: [
            SvgPicture.asset(
              'assets/icons/ic_20_social_${type.name}.svg',
              width: 20,
              height: 20,
            ),
            Text(
              "${type.label}로 계속하기",
              style: MyTypo.button.copyWith(
                color: type == SocialType.naver ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
