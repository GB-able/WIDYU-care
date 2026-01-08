import 'package:care/models/constants/calendar_config.dart';
import 'package:care/models/enums/goal_card_type.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/extensions.dart';
import 'package:care/views/goal/medicine_view_model.dart';
import 'package:care/views/goal/widgets/calendar_widget.dart';
import 'package:care/views/goal/widgets/parent_tile.dart';
import 'package:care/views/goal/widgets/pill_card.dart';
import 'package:care/views/goal/widgets/send_msg_btn.dart';
import 'package:care/views/goal/widgets/summary_tile.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:care/widgets/icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MedicineView extends StatelessWidget {
  const MedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedicineViewModel(),
      child: Consumer<MedicineViewModel>(builder: (context, viewModel, _) {
        final isSameMonth =
            CalendarConfig.today.isSameMonth(viewModel.focusedDay);
        final targetMonth = isSameMonth
            ? DateTime(
                CalendarConfig.today.year, CalendarConfig.today.month - 1)
            : DateTime(viewModel.focusedDay.year, viewModel.focusedDay.month);
        final lastMonthValue = "12/${targetMonth.endOfMonthDay}회";
        return Scaffold(
          backgroundColor: MyColor.grey100,
          appBar: CustomAppBar(title: "약 복용", actions: [
            GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                "assets/icons/ic_22_notification.svg",
                colorFilter:
                    const ColorFilter.mode(MyColor.grey600, BlendMode.srcIn),
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
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 12,
                              children: [
                                ParentTile(
                                  profileImage: null,
                                  name: "송애순",
                                  isSelected: true,
                                ),
                                ParentTile(
                                  profileImage: null,
                                  name: "오일남",
                                  isSelected: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: Column(
                            spacing: 8,
                            children: [
                              Text("약 복용 현황", style: MyTypo.subTitle6),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  spacing: 16,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        viewModel.previousMonth();
                                      },
                                      child: const IconWidget(
                                        icon: "chevron_left",
                                        width: 22,
                                        height: 22,
                                        color: MyColor.grey500,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('yyyy년 M월')
                                          .format(viewModel.focusedDay),
                                      style: MyTypo.subTitle6.copyWith(
                                        color: MyColor.grey700,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        viewModel.nextMonth();
                                      },
                                      child: const IconWidget(
                                        icon: "chevron_right",
                                        width: 22,
                                        height: 22,
                                        color: MyColor.grey500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: SummaryTile(
                                      title:
                                          "${isSameMonth ? '지난' : '${viewModel.focusedDay.month}월'} 달 달성 횟수",
                                      value: lastMonthValue,
                                      isCurrent: false,
                                    ),
                                  ),
                                  Expanded(
                                    child: SummaryTile(
                                      title: "이번 달 진행 횟수",
                                      value:
                                          "12/${CalendarConfig.today.endOfMonthDay}회",
                                      isCurrent: true,
                                    ),
                                  ),
                                ],
                              ),
                              CalendarWidget(
                                type: CalendarFormat.month,
                                percentData: {},
                                focusedDay: viewModel.focusedDay,
                                selectedDay: viewModel.selectedDay,
                                onSelectedDay: (date) {
                                  viewModel.setSelectedDay(date);
                                },
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
                            type: GoalCardType.edit,
                            onTap: () {},
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
      }),
    );
  }
}
