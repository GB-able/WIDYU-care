import 'package:care/providers/goal_provider.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/extensions.dart';
import 'package:care/utils/show_toast.dart';
import 'package:care/views/goal/walk_edit_view_model.dart';
import 'package:care/widgets/custom_app_bar.dart';
import 'package:care/widgets/help_bubble.dart';
import 'package:care/widgets/text_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WalkEditView extends StatelessWidget {
  const WalkEditView({super.key});

  @override
  Widget build(BuildContext context) {
    const int walkMin = 500;
    const int walkMax = 10000;

    return ChangeNotifierProvider(
      create: (_) => WalkEditViewModel(),
      child: Consumer2<GoalProvider, WalkEditViewModel>(
        builder: (context, goalProvider, viewModel, _) {
          return Scaffold(
            appBar: const CustomAppBar(
              title: "걷기",
              type: CustomAppBarType.large,
            ),
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                child: viewModel.goal == null
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("목표 걸음수",
                                        style: MyTypo.subTitle5
                                            .copyWith(color: MyColor.grey800)),
                                    Text("${viewModel.goal!.toComma()}걸음",
                                        style: MyTypo.title3
                                            .copyWith(color: MyColor.primary)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  children: [
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        sliderTheme: const SliderThemeData(
                                          thumbShape: CustomThumb(),
                                          trackHeight: 12,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                        ),
                                      ),
                                      child: Slider(
                                        min: walkMin.toDouble(),
                                        max: walkMax.toDouble(),
                                        divisions: (walkMax - walkMin) ~/ 100,
                                        value: viewModel.goal!.toDouble(),
                                        onChanged: (value) {
                                          viewModel.setGoal(value.toInt());
                                        },
                                        activeColor: MyColor.primary,
                                        inactiveColor: MyColor.orange100,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(walkMin.toComma(),
                                            style: MyTypo.subTitle7.copyWith(
                                                color: MyColor.primary)),
                                        Text(walkMax.toComma(),
                                            style: MyTypo.subTitle7.copyWith(
                                                color: MyColor.primary)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    const HelpBubble(
                                        txt: "수정하신 걷기 목표는 내일 부터 진행돼요!")
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TextBtn(
                            onTap: () {
                              viewModel.save(goalProvider.selectFamilyId!, () {
                                context.pop();
                              }, (error) {
                                showToast(error);
                              });
                            },
                            text: "저장하기",
                            enable: true,
                          )
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomThumb extends SliderComponentShape {
  const CustomThumb();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(32, 32);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 32, height: 32),
        const Radius.circular(16),
      ),
      Paint()..color = MyColor.primary,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 30, height: 30),
        const Radius.circular(15),
      ),
      Paint()..color = Colors.white,
    );
  }
}
