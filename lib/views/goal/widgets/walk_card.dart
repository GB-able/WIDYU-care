import 'package:care/models/enums/app_route.dart';
import 'package:care/models/enums/goal_card_type.dart';
import 'package:care/models/walk_daily.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/extensions.dart';
import 'package:care/views/goal/widgets/card_edit_btn.dart';
import 'package:care/views/goal/widgets/done_tag.dart';
import 'package:care/views/goal/widgets/icon_tile.dart';
import 'package:care/widgets/icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WalkCard extends StatelessWidget {
  const WalkCard(
      {super.key, required this.type, required this.onTap, required this.walk});

  final GoalCardType type;
  final VoidCallback onTap;
  final WalkDaily walk;

  @override
  Widget build(BuildContext context) {
    final isFailed = type == GoalCardType.done && walk.actual < walk.goal;
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
                IconTile(type: IconTileType.walk, isFailed: isFailed),
                const SizedBox(width: 16),
                Text("걷기", style: MyTypo.title3),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${walk.actual.toComma()}걸음",
                    style: MyTypo.title3.copyWith(
                      color: isFailed ? MyColor.grey500 : MyColor.secondary,
                    ),
                  ),
                ),
                if (type == GoalCardType.summary)
                  const IconWidget(
                    icon: "chevron_right",
                    width: 16,
                    height: 16,
                    color: MyColor.grey500,
                  ),
                if (type == GoalCardType.done) DoneTag(isFailed: isFailed),
              ],
            ),
            LinearPercentIndicator(
              percent: walk.actual / walk.goal,
              linearGradient: isFailed
                  ? const LinearGradient(
                      colors: [
                        MyColor.grey300,
                        MyColor.grey300,
                      ],
                    )
                  : const LinearGradient(
                      colors: [
                        MyColor.purple200,
                        MyColor.purple500,
                      ],
                    ),
              backgroundColor: isFailed ? MyColor.grey100 : MyColor.purple100,
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
