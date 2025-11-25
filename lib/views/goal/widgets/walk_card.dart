import 'package:care/models/enums/app_route.dart';
import 'package:care/models/enums/goal_card_type.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/extensions.dart';
import 'package:care/views/goal/widgets/card_edit_btn.dart';
import 'package:care/views/goal/widgets/icon_tile.dart';
import 'package:care/widgets/icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WalkCard extends StatelessWidget {
  const WalkCard({super.key, required this.type, required this.onTap});

  final GoalCardType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final current = 5000;
    final goal = 10000;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          spacing: 20,
          children: [
            Row(
              children: [
                const IconTile(type: IconTileType.walk),
                const SizedBox(width: 16),
                Text("걷기", style: MyTypo.title3),
                const SizedBox(width: 8),
                Expanded(
                  child: Text("${current.toComma()}걸음",
                      style: MyTypo.title3.copyWith(color: MyColor.secondary)),
                ),
                if (type == GoalCardType.summary)
                  const IconWidget(
                    icon: "chevron_right",
                    width: 16,
                    height: 16,
                    color: MyColor.grey500,
                  )
              ],
            ),
            LinearPercentIndicator(
              percent: current / goal,
              linearGradient: const LinearGradient(
                colors: [
                  MyColor.purple200,
                  MyColor.purple500,
                ],
              ),
              backgroundColor: MyColor.purple100,
              lineHeight: 14,
              padding: EdgeInsets.zero,
              barRadius: const Radius.circular(14),
            ),
            if (type == GoalCardType.edit)
              CardEditBtn(
                onTap: () {
                  context.pushNamed(AppRoute.walkEdit.name);
                },
              ),
          ],
        ),
      ),
    );
  }
}
