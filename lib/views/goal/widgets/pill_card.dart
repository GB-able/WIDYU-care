import 'package:care/models/enums/goal_card_type.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/extensions.dart';
import 'package:care/views/goal/widgets/card_edit_btn.dart';
import 'package:care/views/goal/widgets/icon_tile.dart';
import 'package:care/widgets/custom_network_image.dart';
import 'package:care/widgets/icon_widget.dart';
import 'package:flutter/material.dart';

enum DoseStatus { scheduled, missed, done }

class ScheduleItem {
  const ScheduleItem({
    required this.time,
    required this.pillCount,
    required this.proofImageUrl,
    required this.status,
  });

  final String time;
  final int pillCount;
  final String? proofImageUrl;
  final DoseStatus status;
}

class PillCard extends StatelessWidget {
  const PillCard({
    super.key,
    required this.onTap,
    required this.type,
  });

  final VoidCallback onTap;
  final GoalCardType type;

  @override
  Widget build(BuildContext context) {
    final schedules = [
      ScheduleItem(
          time: "10:00",
          pillCount: 1,
          status: DoseStatus.done,
          proofImageUrl: "https://picsum.photos/200/300"),
      ScheduleItem(
          time: "15:00",
          pillCount: 1,
          status: DoseStatus.missed,
          proofImageUrl: null),
      ScheduleItem(
          time: "18:00",
          pillCount: 1,
          status: DoseStatus.scheduled,
          proofImageUrl: null),
      ScheduleItem(
          time: "21:00",
          pillCount: 1,
          status: DoseStatus.scheduled,
          proofImageUrl: null),
    ];
    final takeCount = 1;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          spacing: 12,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 16,
                children: [
                  const IconTile(type: IconTileType.pill),
                  Text("약 복용",
                      style: MyTypo.title3.copyWith(color: MyColor.black)),
                  Expanded(
                    child: Text("$takeCount/${schedules.length}회",
                        style: MyTypo.title3.copyWith(color: MyColor.primary)),
                  ),
                  if (type == GoalCardType.summary)
                    GestureDetector(
                      onTap: onTap,
                      child: const IconWidget(
                        icon: "chevron_right",
                        width: 16,
                        height: 16,
                        color: MyColor.grey500,
                      ),
                    ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  spacing: 10,
                  children: schedules
                      .map((schedule) => _buildScheduleItem(
                          schedule,
                          schedules.length > 3
                              ? 94
                              : (MediaQuery.of(context).size.width -
                                      72 -
                                      (schedules.length - 1) * 10) /
                                  schedules.length))
                      .toList(),
                ),
              ),
            ),
            if (type == GoalCardType.edit)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CardEditBtn(onTap: onTap),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(ScheduleItem schedule, double width) {
    return Column(
      spacing: 8,
      children: [
        Container(
          width: width,
          height: 94,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: schedule.status == DoseStatus.scheduled
                ? MyColor.orange50
                : MyColor.grey100,
          ),
          child: (() {
            switch (schedule.status) {
              case DoseStatus.done:
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomNetworkImage(
                        url: schedule.proofImageUrl!,
                        width: width,
                        height: 94,
                      ),
                    ),
                    Container(
                      width: width,
                      height: 94,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${schedule.pillCount}정 복용완료",
                        style: MyTypo.body2.copyWith(color: MyColor.white),
                      ),
                    ),
                  ],
                );
              case DoseStatus.missed:
                return Column(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/img_40_pill_disabled.png",
                      width: 40,
                      height: 40,
                    ),
                    Text(
                      "${schedule.pillCount}정 미복용",
                      style: MyTypo.body2.copyWith(
                        color: MyColor.grey500,
                      ),
                    ),
                  ],
                );
              case DoseStatus.scheduled:
                return Column(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColor.white,
                        border: Border.all(color: MyColor.primary, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: const IconWidget(
                        icon: "camera_add",
                        width: 24,
                        height: 24,
                        color: MyColor.primary,
                      ),
                    ),
                    Text(
                      "${schedule.pillCount}정 복용예정",
                      style: MyTypo.body2.copyWith(
                        color: MyColor.primary,
                      ),
                    ),
                  ],
                );
            }
          })(),
        ),
        Text(
          schedule.time.toTime(),
          style: MyTypo.subTitle1.copyWith(
            color: schedule.status == DoseStatus.scheduled
                ? MyColor.primary
                : MyColor.grey700,
            decoration: schedule.status == DoseStatus.missed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
      ],
    );
  }
}
