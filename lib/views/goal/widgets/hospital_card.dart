import 'package:care/models/enums/goal_card_type.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/extensions.dart';
import 'package:care/views/goal/widgets/card_edit_btn.dart';
import 'package:care/views/goal/widgets/icon_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HospitalCard extends StatelessWidget {
  const HospitalCard({super.key, required this.type, required this.onTap});
  final GoalCardType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final datetime = DateTime.now().add(const Duration(days: 4));
    final dday = datetime.difference(DateTime.now()).inDays;
    final address = "서울시 강남구 역삼동 123-456";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        spacing: 16,
        children: [
          Row(
            children: [
              const IconTile(type: IconTileType.hospital),
              const SizedBox(width: 16),
              Text("건강검진", style: MyTypo.title3),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "D-${dday <= 0 ? "day" : dday}",
                  style: MyTypo.title3.copyWith(color: MyColor.primary),
                ),
              ),
              SvgPicture.asset("assets/icons/ic_16_chevron_right.svg",
                  colorFilter:
                      const ColorFilter.mode(MyColor.grey500, BlendMode.srcIn)),
            ],
          ),
          Column(
            spacing: 8,
            children: [
              _buildHospitalInfo(
                "건강일정",
                IntrinsicHeight(
                  child: Row(spacing: 12, children: [
                    Text(datetime.onlyMonthDay,
                        style: MyTypo.body1.copyWith(color: MyColor.grey700)),
                    Container(
                      width: 1,
                      height: 15,
                      color: MyColor.grey700,
                    ),
                    Text(datetime.onlyTime,
                        style: MyTypo.body1.copyWith(color: MyColor.grey700))
                  ]),
                ),
              ),
              _buildHospitalInfo(
                  "방문주소",
                  Text(address,
                      style: MyTypo.body1.copyWith(color: MyColor.grey700))),
            ],
          ),
          if (type == GoalCardType.edit) CardEditBtn(onTap: onTap),
        ],
      ),
    );
  }

  Widget _buildHospitalInfo(String label, Widget content) {
    return Row(
      spacing: 12,
      children: [
        Container(
          width: 60,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: MyColor.grey100,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            label,
            style: MyTypo.subTitle2.copyWith(color: MyColor.grey500),
          ),
        ),
        Expanded(child: content),
      ],
    );
  }
}
