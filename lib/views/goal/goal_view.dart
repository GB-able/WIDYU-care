import 'package:care/models/enums/app_route.dart';
import 'package:care/models/enums/goal_card_type.dart';
import 'package:care/models/walk_daily.dart';
import 'package:care/providers/goal_provider.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/views/goal/widgets/calendar_widget.dart';
import 'package:care/views/goal/widgets/hospital_card.dart';
import 'package:care/views/goal/widgets/icon_tile.dart';
import 'package:care/views/goal/widgets/parent_tile.dart';
import 'package:care/views/goal/widgets/pill_card.dart';
import 'package:care/views/goal/widgets/send_msg_btn.dart';
import 'package:care/views/goal/widgets/summary_tile.dart';
import 'package:care/views/goal/widgets/walk_card.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:care/widgets/icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class GoalView extends StatelessWidget {
  const GoalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: MyColor.grey100,
          appBar: CustomAppBar(canBack: false, title: "목표", actions: [
            GestureDetector(
              onTap: () {},
              child: const IconWidget(
                icon: "notification",
                width: 22,
                height: 22,
                color: MyColor.grey600,
              ),
            ),
          ]),
          body: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 56),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    color: MyColor.white,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          child: Container(
                            constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 12,
                              children: provider.families
                                  .map((e) => ParentTile(
                                        profileImage: null,
                                        name: e.name,
                                        isSelected:
                                            e.id == provider.selectFamilyId,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: Column(
                            children: [
                              Text("목표 현황", style: MyTypo.subTitle6),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 7),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Expanded(
                                      child: SummaryTile(
                                        title: "저번주 평균",
                                        value: "80%",
                                        isCurrent: false,
                                      ),
                                    ),
                                    Expanded(
                                      child: SummaryTile(
                                        title: "오늘의 현황",
                                        value: "67%",
                                        isCurrent: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: CalendarWidget(
                                  percentData: {},
                                  type: CalendarFormat.week,
                                  focusedDay: DateTime.now(),
                                  selectedDay:
                                      DateTime.now(), // [TODO] 선택된 날짜 가져오기
                                  onSelectedDay: (date) {
                                    // [TODO] 선택된 날짜 처리
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: MyColor.white,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        color: MyColor.grey100,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      child: Column(
                        spacing: 16,
                        children: [
                          PillCard(
                            type: GoalCardType.summary,
                            onTap: () {
                              context.pushNamed(AppRoute.medicine.name);
                            },
                          ),
                          WalkCard(
                            type: GoalCardType.summary,
                            walk: WalkDaily(
                                date: DateTime.now().toString(),
                                goal: 10000,
                                actual: 5000), // [TODO] 데이터 가져오기
                            onTap: () {
                              context.pushNamed(AppRoute.walk.name);
                            },
                          ),
                          HospitalCard(
                            type: GoalCardType.summary,
                            onTap: () {},
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                useRootNavigator: true,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => Container(
                                  padding: EdgeInsets.fromLTRB(
                                    16,
                                    32,
                                    16,
                                    48 + MediaQuery.of(context).padding.bottom,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: MyColor.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 20,
                                    children: [
                                      Text("목표 추가하기", style: MyTypo.title3),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 8,
                                        children: [
                                          _buildGoalAddRow(
                                              IconTileType.pill, "약 복용", () {}),
                                          _buildGoalAddRow(
                                              IconTileType.walk, "걷기", () {}),
                                          _buildGoalAddRow(
                                              IconTileType.hospital,
                                              "병원 방문",
                                              () {}),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width - 40, 52),
                              backgroundColor: MyColor.white,
                              foregroundColor: MyColor.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const IconWidget(
                                  icon: "plus_small",
                                  width: 24,
                                  height: 24,
                                  color: MyColor.primary,
                                ),
                                Text(
                                  "목표 추가하기",
                                  style: MyTypo.subTitle5.copyWith(
                                    color: MyColor.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SendMsgBtn(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoalAddRow(IconTileType icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: MyColor.grey300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            IconTile(type: icon),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: MyTypo.subTitle5),
            ),
            const IconWidget(
              icon: "chevron_right",
              width: 16,
              height: 16,
              color: MyColor.grey500,
            ),
          ],
        ),
      ),
    );
  }
}
