import 'package:care/models/enums/social_type.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/effects.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum AccountInfoType {
  find,
  notice,
}

class AccountInfo extends StatelessWidget {
  const AccountInfo({
    super.key,
    required this.type,
    required this.name,
    required this.phone,
    this.email,
    this.socials,
  });

  final AccountInfoType type;
  final String name;
  final String phone;
  final String? email;
  final List<String>? socials;

  @override
  Widget build(BuildContext context) {
    final accountInfo = [
      {"title": "이름", "value": "$name 님"},
      {"title": "연락처", "value": phone},
      if (socials != null) {"title": "소셜 연동", "value": socials},
      if (email != null) {"title": "위듀 이메일", "value": email}
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyColor.white,
        boxShadow: [MyEffects.shadow],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.5, vertical: 20),
        child: Column(
          spacing: 12,
          children: [
            Image.asset("assets/images/img_100_mascot.png", width: 100),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, idx) => _buildRow(
                  type,
                  accountInfo[idx]["title"] as String,
                  accountInfo[idx]["value"]!),
              separatorBuilder: (context, _) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: MyColor.grey300, height: 0.5),
              ),
              itemCount: accountInfo.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(AccountInfoType type, String title, Object value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.5),
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: MyTypo.subTitle2.copyWith(color: MyColor.grey600)),
          Expanded(
            child: value is String
                ? Text(
                    value,
                    style: title == "위듀 이메일" && type == AccountInfoType.find
                        ? MyTypo.title3.copyWith(color: MyColor.primary)
                        : MyTypo.body1.copyWith(color: MyColor.grey900),
                    textAlign: TextAlign.end,
                  )
                : Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: (value as List<String>)
                        .where((e) => e != "local")
                        .toList()
                        .map(
                          (e) => Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: SocialType.values
                                  .firstWhere((social) =>
                                      social.name == e.toLowerCase())
                                  .color,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/ic_20_social_$e.svg",
                              width: 20,
                              height: 20,
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
